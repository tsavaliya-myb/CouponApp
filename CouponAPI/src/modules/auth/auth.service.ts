import bcrypt from 'bcryptjs';
import crypto from 'crypto';
import { prisma } from '../../config/db';
import { redis } from '../../config/redis';
import { signAccessToken, signRefreshToken, verifyRefreshToken } from '../../shared/utils/jwt';
import { UnauthorizedError, BadRequestError } from '../../shared/utils/AppError';
import { REDIS_PREFIX, TTL } from '../../shared/constants';
import type { AdminLoginDto, RefreshDto, LogoutDto } from './auth.validator';


export class AuthService {

  // ─── Admin Login ────────────────────────────────────────────────────────────
  async adminLogin(dto: AdminLoginDto) {
    const admin = await prisma.admin.findUnique({
      where: { email: dto.email.toLowerCase() },
    });

    if (!admin) {
      throw UnauthorizedError('Invalid email or password');
    }

    const passwordMatch = await bcrypt.compare(dto.password, admin.passwordHash);
    if (!passwordMatch) {
      throw UnauthorizedError('Invalid email or password');
    }

    const payload = {
      userId: admin.id,
      role:   'admin' as const,
      email:  admin.email,
    };

    const accessToken  = signAccessToken(payload);
    const refreshToken = signRefreshToken(payload);

    // Store refresh token in Redis with 7d TTL
    // Key: refresh:<jti> — value: adminId
    const jti = crypto.randomUUID();
    const refreshKey = `${REDIS_PREFIX.REFRESH_TOKEN}${jti}`;
    await redis.set(refreshKey, admin.id, 'EX', TTL.REFRESH_TOKEN_SEC);

    // Embed jti into the response so client can send it back on /refresh and /logout
    const fullRefreshToken = `${jti}:${refreshToken}`;

    return {
      accessToken,
      refreshToken: fullRefreshToken,
      admin: {
        id:    admin.id,
        email: admin.email,
        name:  admin.name,
      },
    };
  }

  // ─── Refresh Access Token ────────────────────────────────────────────────────
  async refresh(dto: RefreshDto) {
    const [jti, rawRefreshToken] = this._splitRefreshToken(dto.refreshToken);

    // Validate the raw JWT signature first
    let decoded: ReturnType<typeof verifyRefreshToken>;
    try {
      decoded = verifyRefreshToken(rawRefreshToken);
    } catch {
      throw UnauthorizedError('Invalid or expired refresh token');
    }

    // Check Redis for token validity (handles logout/rotation)
    const refreshKey = `${REDIS_PREFIX.REFRESH_TOKEN}${jti}`;
    const storedUserId = await redis.get(refreshKey);
    if (!storedUserId) {
      throw UnauthorizedError('Refresh token has been revoked or expired');
    }

    // Issue a new access token with same payload
    const accessToken = signAccessToken({
      userId: decoded.userId,
      role:   decoded.role,
      email:  decoded.email,
      phone:  decoded.phone,
    });

    return { accessToken };
  }

  // ─── Logout ──────────────────────────────────────────────────────────────────
  async logout(dto: LogoutDto) {
    const [jti] = this._splitRefreshToken(dto.refreshToken);
    const refreshKey = `${REDIS_PREFIX.REFRESH_TOKEN}${jti}`;
    await redis.del(refreshKey);
    return { message: 'Logged out successfully' };
  }

  // ─── Private Helpers ─────────────────────────────────────────────────────────
  private _splitRefreshToken(token: string): [string, string] {
    const sepIdx = token.indexOf(':');
    if (sepIdx === -1) {
      throw BadRequestError('Malformed refresh token');
    }
    const jti = token.slice(0, sepIdx);
    const rawToken = token.slice(sepIdx + 1);
    return [jti, rawToken];
  }
}

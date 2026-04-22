import bcrypt from 'bcryptjs';
import crypto from 'crypto';
import { env } from '../../config/env';
import { prisma } from '../../config/db';
import { redis } from '../../config/redis';
import { signAccessToken, signRefreshToken, verifyRefreshToken } from '../../shared/utils/jwt';
import { UnauthorizedError, BadRequestError } from '../../shared/utils/AppError';
import { REDIS_PREFIX, TTL } from '../../shared/constants';
import type {
  AdminLoginDto,
  RefreshDto,
  LogoutDto,
  AdminLoginResponse,
  RefreshResponse,
  LogoutResponse,
  SendOtpDto,
  VerifyOtpDto,
  SendOtpResponse,
  VerifyOtpResponse,
  SellerSendOtpDto,
  SellerVerifyOtpDto,
  SellerSendOtpResponse,
  SellerVerifyOtpResponse,
} from './auth.validator';
import { signRegistrationToken } from '../../shared/utils/jwt';
import { sendOtpViaMSG91 } from '../../shared/utils/msg91';


export class AuthService {

  // ─── Send OTP ──────────────────────────────────────────────────────────────
  async sendOtp(dto: SendOtpDto): Promise<SendOtpResponse> {
    // Generate 6-digit OTP
    const otp = Math.floor(100000 + Math.random() * 900000).toString();

    // Store in Redis with otp:{phone} key, 5-min TTL
    const otpKey = `${REDIS_PREFIX.OTP}${dto.phone}`;
    await redis.set(otpKey, "123456", 'EX', TTL.OTP_SEC);

    // if (env.MSG91_AUTH_KEY && env.MSG91_TEMPLATE_ID) {
    //   await sendOtpViaMSG91(dto.phone, otp);
    // } else {
    //   console.log(`[DEV] OTP for ${dto.phone} is ${otp}`);
    // }

    return { message: 'OTP sent successfully' };
  }

  // ─── Verify OTP ────────────────────────────────────────────────────────────
  async verifyOtp(dto: VerifyOtpDto): Promise<VerifyOtpResponse> {
    const otpKey = `${REDIS_PREFIX.OTP}${dto.phone}`;
    const storedOtp = await redis.get(otpKey);

    if (!storedOtp || storedOtp !== dto.otp) {
      throw UnauthorizedError('Invalid or expired OTP');
    }

    // OTP matched, delete it
    await redis.del(otpKey);

    // Find user by phone, or create if not exists
    let user = await prisma.user.findUnique({
      where: { phone: dto.phone },
      include: {
        subscription: { select: { status: true, endDate: true } },
      },
    });

    let isNewUser = false;
    if (!user) {
      user = await prisma.user.create({
        data: { phone: dto.phone },
        include: {
          subscription: { select: { status: true, endDate: true } },
        },
      });
      isNewUser = true;
    }

    if (user.status === 'BLOCKED') {
      throw UnauthorizedError('Your account has been blocked');
    }

    // Role is inferred as 'customer' for regular users
    const payload = {
      userId: user.id,
      role: 'customer' as const,
      phone: user.phone,
    };

    const accessToken = signAccessToken(payload);
    const refreshToken = signRefreshToken(payload);

    // Store refresh token in Redis
    const jti = crypto.randomUUID();
    const refreshKey = `${REDIS_PREFIX.REFRESH_TOKEN}${jti}`;
    await redis.set(refreshKey, user.id, 'EX', TTL.REFRESH_TOKEN_SEC);

    const fullRefreshToken = `${jti}:${refreshToken}`;

    return {
      accessToken,
      refreshToken: fullRefreshToken,
      user: {
        id: user.id,
        phone: user.phone,
        name: user.name,
        email: user.email,
        cityId: user.cityId,
        areaId: user.areaId,
        status: user.status,
        subscriptionStatus:
          user.subscription?.status === 'ACTIVE' && user.subscription.endDate > new Date()
            ? 'ACTIVE'
            : 'NONE',
      },
      isNewUser,
    };
  }

  // ─── Seller OTP Flow ────────────────────────────────────────────────────────
  async sellerSendOtp(dto: SellerSendOtpDto): Promise<SellerSendOtpResponse> {
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    const otpKey = `${REDIS_PREFIX.OTP}seller:${dto.phone}`;
    await redis.set(otpKey, "123456", 'EX', TTL.OTP_SEC);

    // if (env.MSG91_AUTH_KEY && env.MSG91_TEMPLATE_ID) {
    //   await sendOtpViaMSG91(dto.phone, otp);
    // } else {
    //   console.log(`[DEV] Seller OTP for ${dto.phone} is ${otp}`);
    // }
    return { message: 'OTP sent successfully' };
  }

  async sellerVerifyOtp(dto: SellerVerifyOtpDto): Promise<SellerVerifyOtpResponse> {
    const otpKey = `${REDIS_PREFIX.OTP}seller:${dto.phone}`;
    const storedOtp = await redis.get(otpKey);

    if (!storedOtp || storedOtp !== dto.otp) {
      throw UnauthorizedError('Invalid or expired OTP');
    }

    await redis.del(otpKey);

    const seller = await prisma.seller.findUnique({
      where: { phone: dto.phone },
    });

    if (!seller) {
      const registrationToken = signRegistrationToken(dto.phone);
      return {
        isRegistered: false,
        registrationToken,
      };
    }

    if (seller.status === 'SUSPENDED') {
      throw UnauthorizedError('Your account stands suspended. Please contact support.');
    }

    const payload = {
      userId: seller.id,
      role: 'seller' as const,
      phone: seller.phone,
    };

    const accessToken = signAccessToken(payload);
    const refreshToken = signRefreshToken(payload);

    const jti = crypto.randomUUID();
    const refreshKey = `${REDIS_PREFIX.REFRESH_TOKEN}${jti}`;
    await redis.set(refreshKey, seller.id, 'EX', TTL.REFRESH_TOKEN_SEC);

    const fullRefreshToken = `${jti}:${refreshToken}`;

    return {
      isRegistered: true,
      status: seller.status,
      accessToken,
      refreshToken: fullRefreshToken,
    };
  }

  // ─── Admin Login ────────────────────────────────────────────────────────────
  async adminLogin(dto: AdminLoginDto): Promise<AdminLoginResponse> {
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
      role: 'admin' as const,
      email: admin.email,
    };

    const accessToken = signAccessToken(payload);
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
        id: admin.id,
        email: admin.email,
        name: admin.name,
      },
    };
  }

  // ─── Refresh Access Token ────────────────────────────────────────────────────
  async refresh(dto: RefreshDto): Promise<RefreshResponse> {
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
      role: decoded.role,
      email: decoded.email,
      phone: decoded.phone,
    });

    return { accessToken };
  }

  // ─── Logout ──────────────────────────────────────────────────────────────────
  async logout(dto: LogoutDto): Promise<LogoutResponse> {
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

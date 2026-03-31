import { prisma } from '../../config/db';
import { signAccessToken, signRefreshToken } from '../../shared/utils/jwt';
import { ConflictError, NotFoundError, BadRequestError } from '../../shared/utils/AppError';
import { REDIS_PREFIX, TTL } from '../../shared/constants';
import { redis } from '../../config/redis';
import crypto from 'crypto';
import type {
  RegisterUserDto,
  UpdateUserDto,
  LoginUserResponse,
  ProfileResponse,
  QrTokenResponse,
} from './users.validator';

export class UsersService {

  // ─── Register (Bypasses OTP for MVP) ────────────────────────────────────────

  async register(dto: RegisterUserDto): Promise<LoginUserResponse> {
    // Note: In full implementation, this should verify OTP first.
    // We are trusting the phone number directly for MVP Phase 3.

    let user = await prisma.user.findUnique({
      where: { phone: dto.phone },
    });

    if (user) {
      // If user already exists, we just rotate tokens (essentially a login)
      // Throw Conflict if the app strictly expects 'register' to fail on duplicate
      // but for ease of use, we update missing details if provided.
      if (dto.name || dto.email || dto.cityId || dto.areaId) {
        user = await prisma.user.update({
          where: { id: user.id },
          data: {
            name: dto.name || user.name,
            email: dto.email || user.email,
            cityId: dto.cityId || user.cityId,
            areaId: dto.areaId || user.areaId,
          }
        });
      }
    } else {
      user = await prisma.user.create({
        data: {
          phone: dto.phone,
          name: dto.name,
          email: dto.email,
          cityId: dto.cityId,
          areaId: dto.areaId,
        },
      });
    }

    if (user.status === 'BLOCKED') {
      throw BadRequestError('User account is blocked. Please contact support.');
    }

    const payload = {
      userId: user.id,
      role: 'customer' as const,
      phone: user.phone,
    };

    const accessToken = signAccessToken(payload);
    const refreshToken = signRefreshToken(payload);

    const jti = crypto.randomUUID();
    const refreshKey = `${REDIS_PREFIX.REFRESH_TOKEN}${jti}`;
    await redis.set(refreshKey, user.id, 'EX', TTL.REFRESH_TOKEN_SEC);

    return {
      accessToken,
      refreshToken: `${jti}:${refreshToken}`,
      user: {
        id: user.id,
        phone: user.phone,
        name: user.name,
        email: user.email,
        cityId: user.cityId,
        areaId: user.areaId,
        status: user.status,
      },
    };
  }

  // ─── Profile Management ───────────────────────────────────────────────────────

  async getProfile(userId: string): Promise<ProfileResponse> {
    const user = await prisma.user.findUnique({
      where: { id: userId },
      include: {
        city: { select: { id: true, name: true } },
        area: { select: { id: true, name: true } },
      },
    });

    if (!user) throw NotFoundError('User profile not found');
    return user;
  }

  async updateProfile(userId: string, dto: UpdateUserDto): Promise<ProfileResponse> {
    const user = await prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw NotFoundError('User profile not found');

    if (dto.email && dto.email !== user.email) {
      const emailTaken = await prisma.user.findFirst({ where: { email: dto.email } });
      if (emailTaken) throw ConflictError('Email is already in use by another account');
    }

    return prisma.user.update({
      where: { id: userId },
      data: dto,
      include: {
        city: { select: { id: true, name: true } },
        area: { select: { id: true, name: true } },
      },
    });
  }
}

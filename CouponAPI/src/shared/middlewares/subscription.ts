import { Request, Response, NextFunction } from 'express';
import { prisma } from '../../config/db';
import { ForbiddenError } from '../utils/AppError';

/**
 * requireSubscription
 *
 * Must be used AFTER authenticate().
 * Checks that the authenticated customer has an active, non-expired subscription.
 *
 * Returns 403 SUBSCRIPTION_REQUIRED if:
 *   - No subscription record exists
 *   - Subscription status is EXPIRED
 *   - Subscription endDate has passed
 *
 * @example
 * router.get('/coupons', authenticate, requireSubscription, controller.list)
 */
export const requireSubscription = async (
  req: Request,
  _res: Response,
  next: NextFunction,
): Promise<void> => {
  try {
    if (!req.user) {
      return next(ForbiddenError('Authentication required'));
    }

    const subscription = await prisma.subscription.findUnique({
      where: { userId: req.user.userId },
      select: { status: true, endDate: true },
    });

    const isActive =
      subscription?.status === 'ACTIVE' &&
      subscription.endDate > new Date();

    if (!isActive) {
      return next(
        ForbiddenError('An active subscription is required to access this feature'),
      );
    }

    next();
  } catch (err) {
    next(err);
  }
};

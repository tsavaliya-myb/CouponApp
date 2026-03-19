/**
 * User roles in the system.
 * Used in JWT payloads and for route authorization.
 */
export type UserRole = 'customer' | 'seller' | 'admin';

export const ROLES = {
  CUSTOMER: 'customer' as UserRole,
  SELLER:   'seller'   as UserRole,
  ADMIN:    'admin'    as UserRole,
};

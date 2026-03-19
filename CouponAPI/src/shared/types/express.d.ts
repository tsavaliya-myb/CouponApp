// Shared TypeScript type extensions and declarations

import { UserRole } from './roles';

// Extend Express Request to carry the authenticated user payload
declare global {
  namespace Express {
    interface Request {
      user?: {
        userId: string;
        role: UserRole;
        // For customers: phone-based identity
        phone?: string;
        // For admins: email-based identity
        email?: string;
        iat: number;
        exp: number;
      };
    }
  }
}

export {};

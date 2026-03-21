export interface AdminUser {
  id: string;
  email: string;
  name: string;
}

export interface AuthData {
  accessToken: string;
  refreshToken: string;
  admin: AdminUser;
}

export interface AuthResponse {
  success: boolean;
  data: AuthData;
}

export interface RefreshTokenResponse {
  success: boolean;
  data: {
    accessToken: string;
  };
}

export interface LogoutResponse {
  success: boolean;
  data: {
    message: string;
  };
}



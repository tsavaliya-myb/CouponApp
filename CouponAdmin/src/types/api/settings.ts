export interface SystemSettings {
  subscription_price: string;
  book_validity_days: string;
  coins_per_subscription: string;
  max_coins_per_transaction: string;
  expiry_reminder_7d_title: string;
  expiry_reminder_7d_body: string;
  expiry_reminder_2d_title: string;
  expiry_reminder_2d_body: string;
  daily_motivation_title: string;
  daily_motivation_body: string;
  [key: string]: string;
}

export interface SystemSettingsResponse {
  success: boolean;
  data: SystemSettings;
}

export type UpdateSystemSettingsPayload = Partial<SystemSettings>;

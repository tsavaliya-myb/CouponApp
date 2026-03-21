export interface WalletSettings {
  coinsPerSubscription: number;
  maxCoinsPerTransaction: number;
}

export interface WalletSettingsResponse {
  success: boolean;
  data: WalletSettings;
}

export interface UpdateWalletSettingsParams {
  coinsPerSubscription?: number;
  maxCoinsPerTransaction?: number;
}

export interface BulkAwardParams {
  amount: number;
  cityId?: string;
  note: string;
}

export interface BulkAwardResponse {
  success: boolean;
  data: {
    awardedCount: number;
    totalCoins: number;
  };
}

export interface WalletOverview {
  totalIssued: number;
  totalUsed: number;
  outstandingLiability: number;
}

export interface WalletOverviewResponse {
  success: boolean;
  data: WalletOverview;
}

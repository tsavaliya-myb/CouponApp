export interface DashboardData {
  activeSubscribers: number;
  revenueThisMonth: number;
  redemptions: {
    today: number;
    thisWeek: number;
  };
  pendingSettlements: number;
  pendingSellers: number;
  coins: {
    awardedThisMonth: number;
    pendingCompensation: number;
  };
  last7Days: {
    date: string;
    subscriptions: number;
    redemptions: number;
  }[];
}

export interface DashboardResponse {
  success: boolean;
  data: DashboardData;
}

export interface NotificationHistoryItem {
  id: string;
  type: string;
  targetType: string;
  targetId: string | null;
  title: string;
  body: string;
  onesignalId: string | null;
  sentAt: string;
}

export interface NotificationHistoryResponse {
  success: boolean;
  data: {
    data: NotificationHistoryItem[];
    meta: {
      totalCount: number;
      page: number;
      limit: number;
    };
  };
}

/**
 * Shared pagination query type used across all list endpoints.
 */
export interface PaginationQuery {
  page:  number;
  limit: number;
}

export interface PaginationMeta {
  page:       number;
  limit:      number;
  total:      number;
  totalPages: number;
}

/**
 * Compute pagination metadata.
 */
export const buildPaginationMeta = (
  total: number,
  { page, limit }: PaginationQuery
): PaginationMeta => ({
  page,
  limit,
  total,
  totalPages: Math.ceil(total / limit),
});

/**
 * Parse and clamp pagination query params from the request.
 * Defaults: page=1, limit=20. Max limit=100.
 */
export const parsePagination = (query: Record<string, unknown>): PaginationQuery => {
  const page  = Math.max(1, parseInt(String(query.page  ?? 1), 10));
  const limit = Math.min(100, Math.max(1, parseInt(String(query.limit ?? 20), 10)));
  return { page, limit };
};

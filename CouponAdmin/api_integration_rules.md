# API Integration Rules & Best Practices

This document defines the standard operating procedures and architectural rules for replacing mock data with real API integrations in this project. All future API implementations must strictly adhere to these rules.

## 1. Architectural Layers (The 3-Layer Approach)
To ensure components remain decoupled from network logic, all API integrations must follow a strict three-layer architecture:
- **API Client / Service Layer (`src/services/*`)**: 
  - Pure generic functions responsible for direct backend communication (e.g., `axios` defaults, generating URL paths, forming payload bodies).
  - No React code or state resides here.
- **State/Caching Layer (`src/hooks/api/*`)**: 
  - Custom React hooks utilizing `@tanstack/react-query` to wrap the service functions.
  - Handles caching, infinite scrolling, pagination, automatic background refetching, and exposes React state (`isLoading`, `isError`, `isSuccess`).
- **UI Component Layer (`src/components/*` & `src/pages/*`)**: 
  - UI components strictly consume data from the custom hooks (e.g., `const { data, isLoading } = useCoupons()`).
  - **Rule:** Never use `fetch` or `axios` directly inside a React component.

## 2. Centralized Configuration
- **Base Client**: Use a centralized `apiClient` instance (e.g., in `src/lib/apiClient.ts` or `src/services/apiClient.ts`) to manage base URLs, timeouts, and default headers globally.
- **Interceptors**: Utilize request/response interceptors to automatically attach Authentication tokens (e.g., `Bearer <token>`) to outgoing requests and handle global `401`/`403` responses gracefully (e.g., clearing local storage and redirecting to login).
- **Environment Variables**: API endpoints must rely on `.env` variables (e.g., `import.meta.env.VITE_API_BASE_URL`). No hard-coded URLs in the source code.

## 3. Strict Type-Safety & Validation
- **Contracts**: Every API endpoint must have precise **Request Payload** and **Expected Response** TypeScript interfaces/types defined in `src/types/` or alongside the service.
- **Runtime Validation**: Use `zod` schemas to optionally validate incoming data for critical endpoints. This ensures that frontend failures due to backend contract changes are caught at the network boundary rather than deep within the React component tree.

## 4. Consistent Error Handling & User Feedback
- **Format Standardization**: Map errors from the backend APIs into a standard custom format (e.g., `{ message: string, code: number }`) before returning them to the UI layers.
- **Mutations (POST/PUT/DELETE)**: Integrate UI Toast notifications (e.g., `sonner` via Shadcn UI) directly in the custom hook callbacks (`onSuccess`, `onError`) to provide immediate user feedback seamlessly.
- **Queries (GET)**: Safely trigger empty states, retry attempts, or inline graphical error states within the component using the `isError` or `error` state from TanStack Query.

## 5. Mock Phasing-Out Strategy
When migrating from mock data to a real API:
1. Define the Types/Zod schemas based on the real API contract.
2. Build the Service function in `src/services/`.
3. Build the TanStack Query hook in `src/hooks/api/`.
4. Replace the mock imports inside the UI Component with the new custom hook.
5. Retain mock structures purely for unit testing or fallback defaults if explicitly required; otherwise, safely delete them.

---
**Note to AI Assistant:** When adapting an API sequentially as requested by the user, read these rules before proceeding. Generate the service, the types, and the query hook, then update the component. Always ask clarifying questions about API contracts if they are missing or ambiguous.

import axios from "axios";

export const apiClient = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || "http://localhost:3000/api/v1",
  headers: {
    "Content-Type": "application/json",
    Accept: "application/json",
  },
});

// Request interceptor to attach tokens
apiClient.interceptors.request.use(
  (config) => {
    // TODO: Get token from your auth store/context or localStorage
    const token = localStorage.getItem("accessToken");
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor for global errors
apiClient.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;

    // Check if error is 401, we have a refresh token, and this request hasn't been retried yet
    if (error.response?.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;

      try {
        const refreshToken = localStorage.getItem("refreshToken");
        if (refreshToken) {
          // Use standard axios to avoid triggering our interceptors infinitely
          const baseURL = import.meta.env.VITE_API_BASE_URL || "http://localhost:3000/api/v1";
          const { data } = await axios.post(`${baseURL}/auth/refresh`, {
            refreshToken,
          });

          if (data.success && data.data.accessToken) {
            const newAccessToken = data.data.accessToken;
            // Save the new token seamlessly
            localStorage.setItem("accessToken", newAccessToken);
            
            // Retry the original failing request with the newly issued token
            originalRequest.headers.Authorization = `Bearer ${newAccessToken}`;
            return apiClient(originalRequest);
          }
        }
      } catch (refreshError) {
        // Drop down here to cleanly purge session if refresh token also fails / is expired
        console.error("Refresh token expired or failed. Forcing logout...");
      }
    }

    // Default 401 handler if token refresh completely failed or couldn't be executed
    if (error.response?.status === 401) {
      console.error("Unauthorized! Redirecting to login...");
      localStorage.removeItem("accessToken");
      localStorage.removeItem("refreshToken");
      localStorage.removeItem("user");
      window.location.href = "/login";
    }
    
    return Promise.reject(error);
  }
);

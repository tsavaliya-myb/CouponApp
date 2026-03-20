import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { BrowserRouter, Route, Routes, Navigate } from "react-router-dom";
import { Toaster as Sonner } from "@/components/ui/sonner";
import { Toaster } from "@/components/ui/toaster";
import { TooltipProvider } from "@/components/ui/tooltip";
import { AdminLayout } from "@/components/admin/AdminLayout";
import Dashboard from "@/pages/admin/Dashboard";
import UsersPage from "@/pages/admin/Users";
import SellersPage from "@/pages/admin/Sellers";
import CouponsPage from "@/pages/admin/Coupons";
import SettlementsPage from "@/pages/admin/Settlements";
import WalletPage from "@/pages/admin/Wallet";
import AnalyticsPage from "@/pages/admin/Analytics";
import NotificationsPage from "@/pages/admin/Notifications";
import CitiesAreasPage from "@/pages/admin/CitiesAreas";
import SettingsPage from "@/pages/admin/Settings";
import NotFound from "./pages/NotFound.tsx";

const queryClient = new QueryClient();

const App = () => (
  <QueryClientProvider client={queryClient}>
    <TooltipProvider>
      <Toaster />
      <Sonner />
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Navigate to="/admin" replace />} />
          <Route path="/admin" element={<AdminLayout />}>
            <Route index element={<Dashboard />} />
            <Route path="users" element={<UsersPage />} />
            <Route path="sellers" element={<SellersPage />} />
            <Route path="coupons" element={<CouponsPage />} />
            <Route path="settlements" element={<SettlementsPage />} />
            <Route path="wallet" element={<WalletPage />} />
            <Route path="analytics" element={<AnalyticsPage />} />
            <Route path="notifications" element={<NotificationsPage />} />
            <Route path="cities" element={<CitiesAreasPage />} />
            <Route path="settings" element={<SettingsPage />} />
          </Route>
          <Route path="*" element={<NotFound />} />
        </Routes>
      </BrowserRouter>
    </TooltipProvider>
  </QueryClientProvider>
);

export default App;

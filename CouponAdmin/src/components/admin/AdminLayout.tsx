import { SidebarProvider, SidebarTrigger } from "@/components/ui/sidebar";
import { AdminSidebar } from "./AdminSidebar";
import { Outlet, useNavigate } from "react-router-dom";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { LogOut } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useAuthContext } from "@/contexts/AuthContext";
import { useLogout } from "@/hooks/api/useAuth";
import { toast } from "sonner";

export function AdminLayout() {
  const navigate = useNavigate();
  const { logout } = useAuthContext();
  const logoutMutation = useLogout();

  const handleLogout = () => {
    logoutMutation.mutate(undefined, {
      onSettled: () => {
        // Regardless of API success or error (e.g token already expired), forcibly logging out local state
        logout();
        navigate("/login");
        toast.info("Logged out successfully");
      }
    });
  };

  return (
    <SidebarProvider>
      <div className="min-h-screen flex w-full bg-background">
        <AdminSidebar />
        <div className="flex-1 flex flex-col min-w-0">
          <header className="h-14 flex items-center justify-between border-b bg-card/80 backdrop-blur-sm px-4 md:px-6 shrink-0 sticky top-0 z-10 w-full overflow-hidden">
            <SidebarTrigger className="shrink-0" />
            <div className="flex items-center gap-1.5 md:gap-2 ml-auto shrink-0 truncate">
              <Button
                variant="ghost"
                size="icon"
                onClick={handleLogout}
                disabled={logoutMutation.isPending}
                title="Logout"
                className="h-9 w-9 text-muted-foreground hover:text-white hover:bg-destructive/90 transition-all shrink-0"
              >
                <LogOut className="h-4 w-4" />
              </Button>
              {/* <div className="h-5 w-px bg-border mx-1 shrink-0" /> */}
              {/* <div className="flex items-center gap-2 md:gap-2.5 shrink-0 pl-1">
                <span className="text-sm text-foreground/80 hidden sm:inline font-semibold">Admin</span>
                <Avatar className="h-8 w-8 ring-2 ring-primary/10 shrink-0">
                  <AvatarFallback className="bg-primary text-primary-foreground text-xs font-bold">
                    AD
                  </AvatarFallback>
                </Avatar>
              </div> */}
            </div>
          </header>
          <main className="flex-1 overflow-auto p-4 md:p-6 lg:p-8">
            <Outlet />
          </main>
        </div>
      </div>
    </SidebarProvider>
  );
}

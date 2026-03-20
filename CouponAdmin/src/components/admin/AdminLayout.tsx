import { SidebarProvider, SidebarTrigger } from "@/components/ui/sidebar";
import { AdminSidebar } from "./AdminSidebar";
import { Outlet } from "react-router-dom";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Bell } from "lucide-react";
import { Button } from "@/components/ui/button";

export function AdminLayout() {
  return (
    <SidebarProvider>
      <div className="min-h-screen flex w-full bg-background">
        <AdminSidebar />
        <div className="flex-1 flex flex-col min-w-0">
          <header className="h-14 flex items-center justify-between border-b bg-card/80 backdrop-blur-sm px-4 md:px-6 shrink-0 sticky top-0 z-10">
            <SidebarTrigger />
            <div className="flex items-center gap-2">
              <Button variant="ghost" size="icon" className="h-9 w-9 text-muted-foreground">
                <Bell className="h-4 w-4" />
              </Button>
              <div className="h-6 w-px bg-border" />
              <div className="flex items-center gap-2.5">
                <span className="text-sm text-muted-foreground hidden sm:inline font-medium">Admin</span>
                <Avatar className="h-8 w-8 ring-2 ring-primary/10">
                  <AvatarFallback className="bg-primary text-primary-foreground text-xs font-semibold">
                    AD
                  </AvatarFallback>
                </Avatar>
              </div>
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

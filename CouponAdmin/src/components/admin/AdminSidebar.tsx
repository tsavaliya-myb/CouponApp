import {
  LayoutDashboard,
  Users,
  Store,
  Ticket,
  Landmark,
  Wallet,
  BarChart3,
  Bell,
  MapPin,
  Settings,
} from "lucide-react";
import { NavLink } from "@/components/NavLink";
import { useLocation } from "react-router-dom";
import {
  Sidebar,
  SidebarContent,
  SidebarGroup,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarHeader,
  useSidebar,
} from "@/components/ui/sidebar";

const coreItems = [
  { title: "Dashboard", url: "/admin", icon: LayoutDashboard },
  { title: "Users", url: "/admin/users", icon: Users },
  { title: "Sellers", url: "/admin/sellers", icon: Store },
  { title: "Coupons", url: "/admin/coupons", icon: Ticket },
];

const operationsItems = [
  { title: "Settlements", url: "/admin/settlements", icon: Landmark },
  { title: "Wallet", url: "/admin/wallet", icon: Wallet },
  { title: "Analytics", url: "/admin/analytics", icon: BarChart3 },
  { title: "Notifications", url: "/admin/notifications", icon: Bell },
];

const configItems = [
  { title: "Cities & Areas", url: "/admin/cities", icon: MapPin },
  { title: "Settings", url: "/admin/settings", icon: Settings },
];

export function AdminSidebar() {
  const { state } = useSidebar();
  const collapsed = state === "collapsed";
  const location = useLocation();
  const currentPath = location.pathname;

  const isActive = (path: string) =>
    path === "/admin" ? currentPath === "/admin" : currentPath.startsWith(path);

  const renderGroup = (label: string, items: typeof coreItems) => (
    <SidebarGroup>
      <SidebarGroupLabel className="text-sidebar-foreground/40 text-[10px] uppercase tracking-widest font-semibold px-2 mb-1">
        {label}
      </SidebarGroupLabel>
      <SidebarGroupContent>
        <SidebarMenu>
          {items.map((item) => (
            <SidebarMenuItem key={item.title}>
              <SidebarMenuButton
                asChild
                isActive={isActive(item.url)}
                tooltip={item.title}
                className="rounded-lg h-10 transition-all duration-200"
              >
                <NavLink
                  to={item.url}
                  end={item.url === "/admin"}
                  activeClassName="bg-sidebar-accent text-sidebar-accent-foreground font-medium"
                >
                  <item.icon className="h-4 w-4" />
                  <span>{item.title}</span>
                </NavLink>
              </SidebarMenuButton>
            </SidebarMenuItem>
          ))}
        </SidebarMenu>
      </SidebarGroupContent>
    </SidebarGroup>
  );

  return (
    <Sidebar collapsible="icon">
      <SidebarHeader className="border-b border-sidebar-border px-4 py-4">
        {!collapsed ? (
          <div className="flex items-center gap-2.5">
            <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-sidebar-primary text-sidebar-primary-foreground text-sm font-bold shadow-md shadow-sidebar-primary/30">
              C
            </div>
            <div className="flex flex-col">
              <span className="text-sm font-semibold text-sidebar-primary-foreground tracking-tight">
                CouponBook
              </span>
              <span className="text-[10px] text-sidebar-foreground/60 font-medium uppercase tracking-widest">
                Admin
              </span>
            </div>
          </div>
        ) : (
          <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-sidebar-primary text-sidebar-primary-foreground text-sm font-bold shadow-md shadow-sidebar-primary/30 mx-auto">
            C
          </div>
        )}
      </SidebarHeader>

      <SidebarContent className="px-2 pt-2">
        {renderGroup("Management", coreItems)}
        {renderGroup("Operations", operationsItems)}
        {renderGroup("Configuration", configItems)}
      </SidebarContent>
    </Sidebar>
  );
}

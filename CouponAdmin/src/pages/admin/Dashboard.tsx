import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import {
  Users,
  IndianRupee,
  TicketCheck,
  Landmark,
  Coins,
  Store,
  Plus,
  CheckCircle,
  Bell,
  TrendingUp,
  ArrowUpRight,
} from "lucide-react";
import {
  dashboardStats,
  subscriptionChartData,
  redemptionChartData,
} from "@/data/mock-data";
import {
  BarChart,
  Bar,
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Area,
  AreaChart,
} from "recharts";
import { useNavigate } from "react-router-dom";

const stats = [
  {
    label: "Active Subscribers",
    value: dashboardStats.activeSubscribers,
    icon: Users,
    trend: "+12%",
    bg: "bg-[hsl(250,55%,96%)]",
    iconBg: "bg-[hsl(250,60%,52%)]",
  },
  {
    label: "Revenue This Month",
    value: `₹${dashboardStats.revenueThisMonth.toLocaleString("en-IN")}`,
    icon: IndianRupee,
    trend: "+8%",
    bg: "bg-[hsl(145,50%,95%)]",
    iconBg: "bg-[hsl(170,60%,42%)]",
  },
  {
    label: "Redemptions Today",
    value: dashboardStats.redemptionsToday,
    icon: TicketCheck,
    trend: "+24%",
    bg: "bg-[hsl(35,80%,95%)]",
    iconBg: "bg-[hsl(35,92%,52%)]",
  },
  {
    label: "This Week",
    value: dashboardStats.redemptionsThisWeek,
    icon: TrendingUp,
    trend: "+18%",
    bg: "bg-[hsl(200,60%,95%)]",
    iconBg: "bg-[hsl(200,70%,50%)]",
  },
  {
    label: "Pending Settlements",
    value: dashboardStats.pendingSettlements,
    icon: Landmark,
    trend: "",
    bg: "bg-[hsl(340,50%,96%)]",
    iconBg: "bg-[hsl(340,65%,52%)]",
  },
  {
    label: "Coins Awarded",
    value: dashboardStats.coinsAwardedThisMonth,
    icon: Coins,
    trend: "+5%",
    bg: "bg-[hsl(270,50%,96%)]",
    iconBg: "bg-[hsl(270,60%,52%)]",
  },
  {
    label: "New Seller Requests",
    value: dashboardStats.newSellerRequests,
    icon: Store,
    trend: "",
    bg: "bg-[hsl(20,60%,95%)]",
    iconBg: "bg-[hsl(20,80%,52%)]",
  },
];

export default function Dashboard() {
  const navigate = useNavigate();

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="animate-in-view">
        <h1 className="text-2xl md:text-3xl font-bold tracking-tight text-foreground">
          Good morning, Admin
        </h1>
        <p className="text-muted-foreground mt-1">
          Here's what's happening across your coupon platform today.
        </p>
      </div>

      {/* Stat Cards */}
      <div className="grid grid-cols-2 md:grid-cols-3 xl:grid-cols-4 gap-4">
        {stats.map((s, i) => (
          <Card
            key={s.label}
            className="border-0 shadow-sm hover:shadow-md transition-all duration-300 overflow-hidden group"
            style={{ animationDelay: `${i * 60}ms` }}
          >
            <CardContent className="p-4 md:p-5">
              <div className="flex items-start justify-between">
                <div className={`p-2.5 rounded-xl ${s.iconBg} text-white shadow-sm`}>
                  <s.icon className="h-4 w-4" />
                </div>
                {s.trend && (
                  <span className="text-[11px] font-medium text-[hsl(170,60%,42%)] bg-[hsl(170,50%,95%)] px-1.5 py-0.5 rounded-md flex items-center gap-0.5">
                    <ArrowUpRight className="h-3 w-3" />
                    {s.trend}
                  </span>
                )}
              </div>
              <div className="mt-3">
                <p className="text-2xl md:text-3xl font-bold tabular-nums tracking-tight">{s.value}</p>
                <p className="text-xs text-muted-foreground mt-0.5 font-medium">{s.label}</p>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* Quick Actions */}
      <div className="flex flex-wrap gap-3 animate-in-view" style={{ animationDelay: "200ms" }}>
        <Button onClick={() => navigate("/admin/coupons")} className="rounded-lg shadow-sm shadow-primary/20 active:scale-[0.97] transition-transform">
          <Plus className="h-4 w-4 mr-1.5" /> Add Coupon
        </Button>
        <Button variant="outline" onClick={() => navigate("/admin/sellers")} className="rounded-lg active:scale-[0.97] transition-transform">
          <CheckCircle className="h-4 w-4 mr-1.5" /> Approve Sellers
        </Button>
        <Button variant="outline" disabled className="rounded-lg">
          <Bell className="h-4 w-4 mr-1.5" /> Send Notification
        </Button>
      </div>

      {/* Charts */}
      <div className="grid md:grid-cols-2 gap-5 animate-in-view" style={{ animationDelay: "300ms" }}>
        <Card className="border-0 shadow-sm">
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-semibold text-foreground">Subscriptions</CardTitle>
            <p className="text-xs text-muted-foreground">Last 7 days</p>
          </CardHeader>
          <CardContent className="h-60">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={subscriptionChartData} barCategoryGap="20%">
                <CartesianGrid strokeDasharray="3 3" stroke="hsl(220, 13%, 90%)" vertical={false} />
                <XAxis dataKey="date" tick={{ fontSize: 11, fill: "hsl(220, 10%, 46%)" }} axisLine={false} tickLine={false} />
                <YAxis tick={{ fontSize: 11, fill: "hsl(220, 10%, 46%)" }} axisLine={false} tickLine={false} />
                <Tooltip
                  contentStyle={{
                    borderRadius: "10px",
                    border: "none",
                    boxShadow: "0 4px 20px hsl(0 0% 0% / 0.08)",
                    fontSize: 12,
                  }}
                />
                <Bar dataKey="subscriptions" fill="hsl(250, 60%, 52%)" radius={[6, 6, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        <Card className="border-0 shadow-sm">
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-semibold text-foreground">Redemptions</CardTitle>
            <p className="text-xs text-muted-foreground">Last 7 days</p>
          </CardHeader>
          <CardContent className="h-60">
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={redemptionChartData}>
                <defs>
                  <linearGradient id="redemptionGrad" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor="hsl(170, 60%, 42%)" stopOpacity={0.2} />
                    <stop offset="100%" stopColor="hsl(170, 60%, 42%)" stopOpacity={0} />
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" stroke="hsl(220, 13%, 90%)" vertical={false} />
                <XAxis dataKey="date" tick={{ fontSize: 11, fill: "hsl(220, 10%, 46%)" }} axisLine={false} tickLine={false} />
                <YAxis tick={{ fontSize: 11, fill: "hsl(220, 10%, 46%)" }} axisLine={false} tickLine={false} />
                <Tooltip
                  contentStyle={{
                    borderRadius: "10px",
                    border: "none",
                    boxShadow: "0 4px 20px hsl(0 0% 0% / 0.08)",
                    fontSize: 12,
                  }}
                />
                <Area
                  type="monotone"
                  dataKey="redemptions"
                  stroke="hsl(170, 60%, 42%)"
                  strokeWidth={2.5}
                  fill="url(#redemptionGrad)"
                  dot={{ r: 3, fill: "hsl(170, 60%, 42%)", stroke: "white", strokeWidth: 2 }}
                />
              </AreaChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}

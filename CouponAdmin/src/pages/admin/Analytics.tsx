import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  BarChart, Bar, LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip,
  ResponsiveContainer, Area, AreaChart, PieChart, Pie, Cell, Legend,
} from "recharts";
import {
  revenueChartData, categoryRedemptionData, topSellers,
  subscriptionChartData, redemptionChartData, mockUsers,
} from "@/data/mock-data";
import { TrendingUp, Users, TicketCheck, IndianRupee, Percent } from "lucide-react";

const PIE_COLORS = [
  "hsl(250, 60%, 52%)",
  "hsl(170, 60%, 42%)",
  "hsl(35, 92%, 52%)",
  "hsl(340, 65%, 52%)",
  "hsl(200, 70%, 50%)",
];

export default function AnalyticsPage() {
  const totalUsers = mockUsers.length;
  const activeUsers = mockUsers.filter((u) => u.status === "active").length;
  const churnRate = (((totalUsers - activeUsers) / totalUsers) * 100).toFixed(1);

  return (
    <div className="space-y-6">
      <div className="animate-in-view">
        <h1 className="text-2xl md:text-3xl font-bold tracking-tight">Analytics</h1>
        <p className="text-muted-foreground mt-1">Revenue, redemptions, user trends, and platform performance.</p>
      </div>

      {/* Quick stats */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 animate-in-view" style={{ animationDelay: "60ms" }}>
        {[
          { label: "Total Users", value: totalUsers, icon: Users, color: "hsl(250,60%,52%)" },
          { label: "Active Rate", value: `${((activeUsers / totalUsers) * 100).toFixed(0)}%`, icon: TrendingUp, color: "hsl(170,60%,42%)" },
          { label: "Total Redemptions", value: "742", icon: TicketCheck, color: "hsl(35,92%,52%)" },
          { label: "Churn Rate", value: `${churnRate}%`, icon: Percent, color: "hsl(340,65%,52%)" },
        ].map((s) => (
          <Card key={s.label} className="border-0 shadow-sm">
            <CardContent className="p-4 flex items-center gap-3">
              <div className="p-2.5 rounded-xl text-white" style={{ backgroundColor: s.color }}><s.icon className="h-4 w-4" /></div>
              <div><p className="text-2xl font-bold tabular-nums">{s.value}</p><p className="text-xs text-muted-foreground font-medium">{s.label}</p></div>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* Revenue over time */}
      <Card className="border-0 shadow-sm animate-in-view" style={{ animationDelay: "120ms" }}>
        <CardHeader className="pb-2">
          <CardTitle className="text-sm font-semibold flex items-center gap-2"><IndianRupee className="h-4 w-4" /> Revenue Breakdown (Monthly)</CardTitle>
        </CardHeader>
        <CardContent className="h-72">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={revenueChartData} barCategoryGap="20%">
              <CartesianGrid strokeDasharray="3 3" stroke="hsl(220,13%,90%)" vertical={false} />
              <XAxis dataKey="month" tick={{ fontSize: 11, fill: "hsl(220,10%,46%)" }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fontSize: 11, fill: "hsl(220,10%,46%)" }} axisLine={false} tickLine={false} tickFormatter={(v) => `₹${(v / 1000).toFixed(0)}k`} />
              <Tooltip contentStyle={{ borderRadius: 10, border: "none", boxShadow: "0 4px 20px hsl(0 0% 0% / 0.08)", fontSize: 12 }} formatter={(v: number) => `₹${v.toLocaleString("en-IN")}`} />
              <Bar dataKey="subscriptions" fill="hsl(250,60%,52%)" radius={[4, 4, 0, 0]} name="Subscriptions" />
              <Bar dataKey="commission" fill="hsl(170,60%,42%)" radius={[4, 4, 0, 0]} name="Commission" />
            </BarChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      <div className="grid md:grid-cols-2 gap-5">
        {/* Redemptions by Category */}
        <Card className="border-0 shadow-sm animate-in-view" style={{ animationDelay: "180ms" }}>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-semibold">Redemptions by Category</CardTitle>
          </CardHeader>
          <CardContent className="h-64 flex items-center justify-center">
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie data={categoryRedemptionData} dataKey="redemptions" nameKey="category" cx="50%" cy="50%" outerRadius={80} innerRadius={45} paddingAngle={3} strokeWidth={0}>
                  {categoryRedemptionData.map((_, i) => <Cell key={i} fill={PIE_COLORS[i % PIE_COLORS.length]} />)}
                </Pie>
                <Tooltip contentStyle={{ borderRadius: 10, border: "none", boxShadow: "0 4px 20px hsl(0 0% 0% / 0.08)", fontSize: 12 }} />
                <Legend iconSize={8} wrapperStyle={{ fontSize: 11 }} />
              </PieChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        {/* Top Sellers */}
        <Card className="border-0 shadow-sm animate-in-view" style={{ animationDelay: "240ms" }}>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-semibold">Top Sellers by Redemptions</CardTitle>
          </CardHeader>
          <CardContent className="h-64">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={topSellers} layout="vertical" barCategoryGap="20%">
                <CartesianGrid strokeDasharray="3 3" stroke="hsl(220,13%,90%)" horizontal={false} />
                <XAxis type="number" tick={{ fontSize: 11, fill: "hsl(220,10%,46%)" }} axisLine={false} tickLine={false} />
                <YAxis type="category" dataKey="name" tick={{ fontSize: 11, fill: "hsl(220,10%,46%)" }} axisLine={false} tickLine={false} width={110} />
                <Tooltip contentStyle={{ borderRadius: 10, border: "none", boxShadow: "0 4px 20px hsl(0 0% 0% / 0.08)", fontSize: 12 }} />
                <Bar dataKey="redemptions" fill="hsl(250,60%,52%)" radius={[0, 4, 4, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
      </div>

      {/* Subscription & Redemption Trends */}
      <div className="grid md:grid-cols-2 gap-5 animate-in-view" style={{ animationDelay: "300ms" }}>
        <Card className="border-0 shadow-sm">
          <CardHeader className="pb-2"><CardTitle className="text-sm font-semibold">Subscription Trend</CardTitle></CardHeader>
          <CardContent className="h-52">
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={subscriptionChartData}>
                <defs>
                  <linearGradient id="subGrad" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor="hsl(250,60%,52%)" stopOpacity={0.15} />
                    <stop offset="100%" stopColor="hsl(250,60%,52%)" stopOpacity={0} />
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" stroke="hsl(220,13%,90%)" vertical={false} />
                <XAxis dataKey="date" tick={{ fontSize: 10, fill: "hsl(220,10%,46%)" }} axisLine={false} tickLine={false} />
                <YAxis tick={{ fontSize: 10, fill: "hsl(220,10%,46%)" }} axisLine={false} tickLine={false} />
                <Tooltip contentStyle={{ borderRadius: 10, border: "none", boxShadow: "0 4px 20px hsl(0 0% 0% / 0.08)", fontSize: 12 }} />
                <Area type="monotone" dataKey="subscriptions" stroke="hsl(250,60%,52%)" strokeWidth={2} fill="url(#subGrad)" dot={{ r: 3, fill: "hsl(250,60%,52%)", stroke: "white", strokeWidth: 2 }} />
              </AreaChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardHeader className="pb-2"><CardTitle className="text-sm font-semibold">Redemption Trend</CardTitle></CardHeader>
          <CardContent className="h-52">
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={redemptionChartData}>
                <defs>
                  <linearGradient id="redGrad2" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="0%" stopColor="hsl(170,60%,42%)" stopOpacity={0.15} />
                    <stop offset="100%" stopColor="hsl(170,60%,42%)" stopOpacity={0} />
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" stroke="hsl(220,13%,90%)" vertical={false} />
                <XAxis dataKey="date" tick={{ fontSize: 10, fill: "hsl(220,10%,46%)" }} axisLine={false} tickLine={false} />
                <YAxis tick={{ fontSize: 10, fill: "hsl(220,10%,46%)" }} axisLine={false} tickLine={false} />
                <Tooltip contentStyle={{ borderRadius: 10, border: "none", boxShadow: "0 4px 20px hsl(0 0% 0% / 0.08)", fontSize: 12 }} />
                <Area type="monotone" dataKey="redemptions" stroke="hsl(170,60%,42%)" strokeWidth={2} fill="url(#redGrad2)" dot={{ r: 3, fill: "hsl(170,60%,42%)", stroke: "white", strokeWidth: 2 }} />
              </AreaChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}

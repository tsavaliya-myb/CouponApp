import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import {
  BarChart, Bar, LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip,
  ResponsiveContainer, Area, AreaChart, PieChart, Pie, Cell, Legend,
} from "recharts";
import {
  revenueChartData, categoryRedemptionData, topSellers,
  subscriptionChartData, redemptionChartData,
} from "@/data/mock-data";
import { TrendingUp, Users, TicketCheck, IndianRupee, Percent, Loader2 } from "lucide-react";

import { useAnalyticsSubscriptions, useAnalyticsRedemptions, useAnalyticsTopSellers, useAnalyticsChurn, useAnalyticsCategoryRedemptions, useAnalyticsRevenue } from "@/hooks/api/useAnalytics";

const PIE_COLORS = [
  "hsl(250, 60%, 52%)",
  "hsl(170, 60%, 42%)",
  "hsl(35, 92%, 52%)",
  "hsl(340, 65%, 52%)",
  "hsl(200, 70%, 50%)",
];

export default function AnalyticsPage() {
  const [revenueGroupBy, setRevenueGroupBy] = useState<"day" | "week" | "year">("year");

  const { data: churnData, isLoading: isChurnLoading } = useAnalyticsChurn();
  const { data: redemptionsData, isLoading: isRedemptionsLoading } = useAnalyticsRedemptions({});
  const { data: topSellersData, isLoading: isSellersLoading } = useAnalyticsTopSellers({ limit: 5 });
  const { data: subscriptionsData, isLoading: isSubsLoading } = useAnalyticsSubscriptions("month");
  const { data: categoryData, isLoading: isCategoryLoading } = useAnalyticsCategoryRedemptions();
  const { data: revenueData, isLoading: isRevenueLoading } = useAnalyticsRevenue(revenueGroupBy);

  const churn = churnData?.data;
  const activeSubs = churn?.activeSubscriptions || 0;
  const expiredSubs = churn?.expiredSubscriptions || 0;
  const totalSubs = activeSubs + expiredSubs;

  const activeRateStr = totalSubs > 0 ? ((activeSubs / totalSubs) * 100).toFixed(0) : "0";
  const churnRateStr = totalSubs > 0 ? ((expiredSubs / totalSubs) * 100).toFixed(1) : "0.0";

  const liveTotalRedemptions = redemptionsData?.data?.totalRedemptions || 0;
  const liveTotalSubs = subscriptionsData?.data?.totalCount || 0;

  const liveTopSellers = topSellersData?.data || [];
  const topSellersChartData = liveTopSellers.length > 0 ? liveTopSellers.map(s => ({ name: s.businessName, redemptions: s.redemptions })) : topSellers;

  const liveCategoryData = categoryData?.data || [];
  const categoryChartData = liveCategoryData.length > 0 ? liveCategoryData : categoryRedemptionData;

  const liveRevenueData = revenueData?.data || [];
  const revenueBarChartData = liveRevenueData.length > 0 ? liveRevenueData : revenueChartData;

  return (
    <div className="space-y-6">
      <div className="animate-in-view">
        <h1 className="text-2xl md:text-3xl font-bold tracking-tight">Analytics</h1>
        <p className="text-muted-foreground mt-1">Revenue, redemptions, user trends, and platform performance.</p>
      </div>

      {/* Quick stats */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 animate-in-view" style={{ animationDelay: "60ms" }}>
        {[
          { label: "Total Subscriptions", value: isSubsLoading ? "..." : liveTotalSubs, icon: Users, color: "hsl(250,60%,52%)" },
          { label: "Active Rate", value: isChurnLoading ? "..." : `${activeRateStr}%`, icon: TrendingUp, color: "hsl(170,60%,42%)" },
          { label: "Total Redemptions", value: isRedemptionsLoading ? "..." : liveTotalRedemptions.toLocaleString(), icon: TicketCheck, color: "hsl(35,92%,52%)" },
          { label: "Churn Rate", value: isChurnLoading ? "..." : `${churnRateStr}%`, icon: Percent, color: "hsl(340,65%,52%)" },
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
        <CardHeader className="pb-2 flex flex-row items-center justify-between space-y-0">
          <div className="flex items-center gap-2">
            <CardTitle className="text-sm font-semibold flex items-center gap-2">
              <IndianRupee className="h-4 w-4" /> Revenue Breakdown
            </CardTitle>
            {isRevenueLoading && <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />}
          </div>
          <Select value={revenueGroupBy} onValueChange={(val: "day" | "week" | "year") => setRevenueGroupBy(val)}>
            <SelectTrigger className="w-[110px] h-8 text-xs rounded-lg bg-muted/50 border-0 focus:ring-0">
              <SelectValue />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="year" className="text-xs">Monthly</SelectItem>
              <SelectItem value="week" className="text-xs">Weekly</SelectItem>
              <SelectItem value="day" className="text-xs">Daily</SelectItem>
            </SelectContent>
          </Select>
        </CardHeader>
        <CardContent className="h-72">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={revenueBarChartData} barCategoryGap="20%">
              <CartesianGrid strokeDasharray="3 3" stroke="hsl(220,13%,90%)" vertical={false} />
              <XAxis dataKey="label" tick={{ fontSize: 11, fill: "hsl(220,10%,46%)" }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fontSize: 11, fill: "hsl(220,10%,46%)" }} axisLine={false} tickLine={false} tickFormatter={(v) => `₹${(v / 1000).toFixed(0)}k`} />
              <Tooltip contentStyle={{ borderRadius: 10, border: "none", boxShadow: "0 4px 20px hsl(0 0% 0% / 0.08)", fontSize: 12 }} formatter={(v: number) => `₹${v.toLocaleString("en-IN")}`} />
              <Bar dataKey="subscriptionRevenue" fill="hsl(250,60%,52%)" radius={[4, 4, 0, 0]} name="Subscriptions" />
              <Bar dataKey="commissionRevenue" fill="hsl(170,60%,42%)" radius={[4, 4, 0, 0]} name="Commission" />
            </BarChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      <div className="grid md:grid-cols-2 gap-5">
        {/* Redemptions by Category */}
        <Card className="border-0 shadow-sm animate-in-view" style={{ animationDelay: "180ms" }}>
          <CardHeader className="pb-2 flex flex-row items-center justify-between space-y-0">
            <CardTitle className="text-sm font-semibold">Redemptions by Category</CardTitle>
            {isCategoryLoading && <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />}
          </CardHeader>
          <CardContent className="h-64 flex items-center justify-center">
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie data={categoryChartData} dataKey="redemptions" nameKey="category" cx="50%" cy="50%" outerRadius={80} innerRadius={45} paddingAngle={3} strokeWidth={0}>
                  {categoryChartData.map((_, i) => <Cell key={i} fill={PIE_COLORS[i % PIE_COLORS.length]} />)}
                </Pie>
                <Tooltip contentStyle={{ borderRadius: 10, border: "none", boxShadow: "0 4px 20px hsl(0 0% 0% / 0.08)", fontSize: 12 }} />
                <Legend iconSize={8} wrapperStyle={{ fontSize: 11 }} />
              </PieChart>
            </ResponsiveContainer>
          </CardContent>
        </Card>

        {/* Top Sellers */}
        <Card className="border-0 shadow-sm animate-in-view" style={{ animationDelay: "240ms" }}>
          <CardHeader className="pb-2 flex flex-row items-center justify-between space-y-0">
            <CardTitle className="text-sm font-semibold">Top Sellers by Redemptions</CardTitle>
            {isSellersLoading && <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />}
          </CardHeader>
          <CardContent className="h-64">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={topSellersChartData} layout="vertical" barCategoryGap="20%">
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
      {/* <div className="grid md:grid-cols-2 gap-5 animate-in-view" style={{ animationDelay: "300ms" }}>
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
      </div> */}
    </div>
  );
}

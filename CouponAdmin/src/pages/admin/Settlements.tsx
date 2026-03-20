import { useState } from "react";
import { mockSettlements, type Settlement } from "@/data/mock-data";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from "@/components/ui/sheet";
import { Landmark, CheckCircle2, Clock, IndianRupee, Coins, Download } from "lucide-react";

export default function SettlementsPage() {
  const [weekFilter, setWeekFilter] = useState("all");
  const [statusFilter, setStatusFilter] = useState("all");
  const [selected, setSelected] = useState<Settlement | null>(null);

  const weeks = [...new Set(mockSettlements.map((s) => s.weekLabel))];

  const filtered = mockSettlements.filter((s) => {
    if (weekFilter !== "all" && s.weekLabel !== weekFilter) return false;
    if (statusFilter === "pending" && s.commissionStatus !== "pending") return false;
    if (statusFilter === "paid" && s.commissionStatus !== "paid") return false;
    return true;
  });

  const totalPending = mockSettlements.filter((s) => s.commissionStatus === "pending").reduce((a, s) => a + s.commissionAmount, 0);
  const totalCoinPending = mockSettlements.filter((s) => s.coinCompensationStatus === "pending").reduce((a, s) => a + s.coinCompensation, 0);
  const totalPaid = mockSettlements.filter((s) => s.commissionStatus === "paid").reduce((a, s) => a + s.commissionAmount, 0);

  return (
    <div className="space-y-6">
      <div className="animate-in-view">
        <h1 className="text-2xl md:text-3xl font-bold tracking-tight">Settlement Management</h1>
        <p className="text-muted-foreground mt-1">Track weekly commission and coin compensation payments.</p>
      </div>

      {/* Summary cards */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 animate-in-view" style={{ animationDelay: "60ms" }}>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2.5 rounded-xl bg-[hsl(35,92%,52%)] text-white"><Clock className="h-4 w-4" /></div>
            <div>
              <p className="text-2xl font-bold tabular-nums">₹{totalPending.toLocaleString("en-IN")}</p>
              <p className="text-xs text-muted-foreground font-medium">Pending Commission</p>
            </div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2.5 rounded-xl bg-[hsl(270,60%,52%)] text-white"><Coins className="h-4 w-4" /></div>
            <div>
              <p className="text-2xl font-bold tabular-nums">₹{totalCoinPending.toLocaleString("en-IN")}</p>
              <p className="text-xs text-muted-foreground font-medium">Pending Coin Compensation</p>
            </div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2.5 rounded-xl bg-[hsl(170,60%,42%)] text-white"><CheckCircle2 className="h-4 w-4" /></div>
            <div>
              <p className="text-2xl font-bold tabular-nums">₹{totalPaid.toLocaleString("en-IN")}</p>
              <p className="text-xs text-muted-foreground font-medium">Total Paid</p>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <div className="flex flex-wrap gap-3 animate-in-view" style={{ animationDelay: "120ms" }}>
        <Select value={weekFilter} onValueChange={setWeekFilter}>
          <SelectTrigger className="w-44 rounded-lg"><SelectValue placeholder="Week" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Weeks</SelectItem>
            {weeks.map((w) => <SelectItem key={w} value={w}>{w}</SelectItem>)}
          </SelectContent>
        </Select>
        <Select value={statusFilter} onValueChange={setStatusFilter}>
          <SelectTrigger className="w-40 rounded-lg"><SelectValue placeholder="Status" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Status</SelectItem>
            <SelectItem value="pending">Pending</SelectItem>
            <SelectItem value="paid">Paid</SelectItem>
          </SelectContent>
        </Select>
        <Button variant="outline" className="ml-auto rounded-lg" disabled>
          <Download className="h-4 w-4 mr-1.5" /> Export CSV
        </Button>
      </div>

      {/* Table */}
      <Card className="border-0 shadow-sm animate-in-view" style={{ animationDelay: "180ms" }}>
        <Table>
          <TableHeader>
            <TableRow className="bg-muted/30">
              <TableHead>Seller</TableHead>
              <TableHead>Week</TableHead>
              <TableHead className="text-right">Redemptions</TableHead>
              <TableHead className="text-right">Commission</TableHead>
              <TableHead>Status</TableHead>
              <TableHead className="text-right">Coins Used</TableHead>
              <TableHead className="text-right">Coin Comp.</TableHead>
              <TableHead>Coin Status</TableHead>
              <TableHead></TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {filtered.map((s) => (
              <TableRow key={s.id} className="cursor-pointer hover:bg-accent/40" onClick={() => setSelected(s)}>
                <TableCell className="font-medium">{s.sellerName}</TableCell>
                <TableCell className="text-muted-foreground text-sm">{s.weekLabel}</TableCell>
                <TableCell className="text-right tabular-nums">{s.totalRedemptions}</TableCell>
                <TableCell className="text-right tabular-nums font-medium">₹{s.commissionAmount.toLocaleString("en-IN")}</TableCell>
                <TableCell>
                  <Badge variant={s.commissionStatus === "paid" ? "default" : "secondary"} className={s.commissionStatus === "paid" ? "bg-[hsl(170,60%,42%)] hover:bg-[hsl(170,60%,38%)]" : "bg-[hsl(35,80%,95%)] text-[hsl(35,92%,40%)] hover:bg-[hsl(35,80%,90%)]"}>
                    {s.commissionStatus === "paid" ? "Paid" : "Pending"}
                  </Badge>
                </TableCell>
                <TableCell className="text-right tabular-nums">{s.coinsUsed}</TableCell>
                <TableCell className="text-right tabular-nums">₹{s.coinCompensation}</TableCell>
                <TableCell>
                  <Badge variant={s.coinCompensationStatus === "paid" ? "default" : "secondary"} className={s.coinCompensationStatus === "paid" ? "bg-[hsl(170,60%,42%)] hover:bg-[hsl(170,60%,38%)]" : "bg-[hsl(35,80%,95%)] text-[hsl(35,92%,40%)] hover:bg-[hsl(35,80%,90%)]"}>
                    {s.coinCompensationStatus === "paid" ? "Paid" : "Pending"}
                  </Badge>
                </TableCell>
                <TableCell>
                  {s.commissionStatus === "pending" && (
                    <Button size="sm" variant="outline" className="rounded-lg text-xs" onClick={(e) => { e.stopPropagation(); }}>
                      Mark Paid
                    </Button>
                  )}
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </Card>

      {/* Detail Sheet */}
      <Sheet open={!!selected} onOpenChange={() => setSelected(null)}>
        <SheetContent className="sm:max-w-md rounded-l-2xl">
          <SheetHeader>
            <SheetTitle>{selected?.sellerName}</SheetTitle>
            <SheetDescription>Week: {selected?.weekLabel}</SheetDescription>
          </SheetHeader>
          {selected && (
            <div className="mt-6 space-y-4">
              <div className="bg-muted/40 rounded-xl p-4 space-y-3">
                <div className="flex justify-between text-sm"><span className="text-muted-foreground">Total Redemptions</span><span className="font-semibold tabular-nums">{selected.totalRedemptions}</span></div>
                <div className="flex justify-between text-sm"><span className="text-muted-foreground">Commission Amount</span><span className="font-semibold tabular-nums">₹{selected.commissionAmount.toLocaleString("en-IN")}</span></div>
                <div className="flex justify-between text-sm"><span className="text-muted-foreground">Commission Status</span><Badge variant={selected.commissionStatus === "paid" ? "default" : "secondary"} className={selected.commissionStatus === "paid" ? "bg-[hsl(170,60%,42%)]" : ""}>{selected.commissionStatus}</Badge></div>
              </div>
              <div className="bg-muted/40 rounded-xl p-4 space-y-3">
                <div className="flex justify-between text-sm"><span className="text-muted-foreground">Coins Used at Seller</span><span className="font-semibold tabular-nums">{selected.coinsUsed}</span></div>
                <div className="flex justify-between text-sm"><span className="text-muted-foreground">Coin Compensation</span><span className="font-semibold tabular-nums">₹{selected.coinCompensation}</span></div>
                <div className="flex justify-between text-sm"><span className="text-muted-foreground">Coin Comp. Status</span><Badge variant={selected.coinCompensationStatus === "paid" ? "default" : "secondary"} className={selected.coinCompensationStatus === "paid" ? "bg-[hsl(170,60%,42%)]" : ""}>{selected.coinCompensationStatus}</Badge></div>
              </div>
              {selected.commissionStatus === "pending" && (
                <div className="flex gap-2 pt-2">
                  <Button className="flex-1 rounded-lg">Mark Commission Paid</Button>
                  <Button variant="outline" className="flex-1 rounded-lg">Mark Coin Comp. Paid</Button>
                </div>
              )}
            </div>
          )}
        </SheetContent>
      </Sheet>
    </div>
  );
}

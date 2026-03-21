import { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from "@/components/ui/sheet";
import { Landmark, CheckCircle2, Clock, IndianRupee, Coins, Download, Loader2, AlertTriangle, Store, Search } from "lucide-react";
import { format } from "date-fns";
import { toast } from "sonner";

import { useSettlements, useMarkSettlementPaid } from "@/hooks/api/useSettlements";
import { Settlement, MarkSettlementPaidParams } from "@/types/api/settlements";

export default function SettlementsPage() {
  const [searchQuery, setSearchQuery] = useState("");
  const [selected, setSelected] = useState<Settlement | null>(null);

  const { data: settlementsData, isLoading, isError } = useSettlements({
    page: 1,
    limit: 50,
  });
  const settlements = settlementsData?.data || [];
  
  const displayedSettlements = settlements.filter(s => 
    !searchQuery || s.seller?.businessName?.toLowerCase().includes(searchQuery.toLowerCase())
  );
  const markPaidMutation = useMarkSettlementPaid();

  const handleMarkPaid = (id: string, params: MarkSettlementPaidParams) => {
    const toastId = toast.loading("Confirming transfer...");
    markPaidMutation.mutate({ id, data: params }, {
      onSuccess: () => toast.success("Settlement marked successfully", { id: toastId }),
      onError: () => toast.error("Failed to update settlement", { id: toastId })
    });
  };

  const totalPending = settlements.filter((s) => s.commissionStatus === "PENDING").reduce((a, s) => a + s.commissionTotal, 0);
  const totalCoinPending = settlements.filter((s) => s.coinCompStatus === "PENDING").reduce((a, s) => a + s.coinCompensationTotal, 0);
  const totalPaid = settlements.filter((s) => s.commissionStatus === "PAID").reduce((a, s) => a + s.commissionTotal, 0);

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
        <div className="relative w-full max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input 
            type="search" 
            placeholder="Search by seller name..." 
            className="pl-9 rounded-lg"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </div>
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
            {isLoading ? (
              <TableRow>
                <TableCell colSpan={9} className="h-32 text-center">
                  <div className="flex flex-col items-center justify-center text-muted-foreground space-y-2">
                    <Loader2 className="h-6 w-6 animate-spin" />
                    <span>Loading settlements...</span>
                  </div>
                </TableCell>
              </TableRow>
            ) : isError ? (
              <TableRow>
                <TableCell colSpan={9} className="h-32 text-center">
                  <div className="flex flex-col items-center justify-center text-destructive space-y-2">
                    <AlertTriangle className="h-6 w-6" />
                    <span>Failed to load settlements</span>
                  </div>
                </TableCell>
              </TableRow>
            ) : displayedSettlements.length === 0 ? (
              <TableRow>
                <TableCell colSpan={9} className="text-center py-12 text-muted-foreground">No settlements found matching "{searchQuery}"</TableCell>
              </TableRow>
            ) : displayedSettlements.map((s) => (
              <TableRow key={s.id} className="cursor-pointer hover:bg-accent/40" onClick={() => setSelected(s)}>
                <TableCell className="font-medium">{s.seller?.businessName}</TableCell>
                <TableCell className="text-muted-foreground text-xs font-mono">{format(new Date(s.weekStart), "MMM d")} - {format(new Date(s.weekEnd), "MMM d")}</TableCell>
                <TableCell className="text-right tabular-nums text-muted-foreground">0</TableCell>
                <TableCell className="text-right tabular-nums font-medium">₹{s.commissionTotal.toLocaleString("en-IN")}</TableCell>
                <TableCell>
                  <Badge variant={s.commissionStatus === "PAID" ? "default" : "secondary"} className={s.commissionStatus === "PAID" ? "bg-[hsl(170,60%,42%)] hover:bg-[hsl(170,60%,38%)]" : "bg-[hsl(35,80%,95%)] text-[hsl(35,92%,40%)] hover:bg-[hsl(35,80%,90%)]"}>
                    {s.commissionStatus === "PAID" ? "Paid" : "Pending"}
                  </Badge>
                </TableCell>
                <TableCell className="text-right tabular-nums text-muted-foreground">0</TableCell>
                <TableCell className="text-right tabular-nums">₹{s.coinCompensationTotal.toLocaleString("en-IN")}</TableCell>
                <TableCell>
                  <Badge variant={s.coinCompStatus === "PAID" ? "default" : "secondary"} className={s.coinCompStatus === "PAID" ? "bg-[hsl(170,60%,42%)] hover:bg-[hsl(170,60%,38%)]" : "bg-[hsl(35,80%,95%)] text-[hsl(35,92%,40%)] hover:bg-[hsl(35,80%,90%)]"}>
                    {s.coinCompStatus === "PAID" ? "Paid" : "Pending"}
                  </Badge>
                </TableCell>
                <TableCell>
                  {(s.commissionStatus === "PENDING" || s.coinCompStatus === "PENDING") && (
                    <Button 
                      size="sm" 
                      variant="outline" 
                      className="rounded-lg text-xs" 
                      disabled={markPaidMutation.isPending}
                      onClick={(e) => { 
                        e.stopPropagation(); 
                        handleMarkPaid(s.id, { 
                          commissionPaid: s.commissionStatus === "PENDING" ? true : undefined,
                          coinCompPaid: s.coinCompStatus === "PENDING" ? true : undefined
                        });
                      }}
                    >
                      {markPaidMutation.isPending ? <Loader2 className="h-4 w-4 animate-spin" /> : "Mark Paid"}
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
            <SheetTitle>{selected?.seller?.businessName}</SheetTitle>
            <SheetDescription>Week: {selected ? `${format(new Date(selected.weekStart), "MMM d")} - ${format(new Date(selected.weekEnd), "MMM d, yyyy")}` : ""}</SheetDescription>
          </SheetHeader>
          {selected && (
            <div className="mt-6 space-y-4">
              <div className="bg-muted/40 rounded-xl p-4 space-y-3">
                <div className="flex justify-between text-sm"><span className="text-muted-foreground">Total Redemptions (WIP)</span><span className="font-semibold tabular-nums">0</span></div>
                <div className="flex justify-between text-sm"><span className="text-muted-foreground">Commission Amount</span><span className="font-semibold tabular-nums">₹{selected.commissionTotal.toLocaleString("en-IN")}</span></div>
                <div className="flex justify-between text-sm"><span className="text-muted-foreground">Commission Status</span><Badge variant={selected.commissionStatus === "PAID" ? "default" : "secondary"} className={selected.commissionStatus === "PAID" ? "bg-[hsl(170,60%,42%)]" : ""}>{selected.commissionStatus}</Badge></div>
              </div>
              <div className="bg-muted/40 rounded-xl p-4 space-y-3">
                <div className="flex justify-between text-sm"><span className="text-muted-foreground">Coins Used at Seller (WIP)</span><span className="font-semibold tabular-nums">0</span></div>
                <div className="flex justify-between text-sm"><span className="text-muted-foreground">Coin Compensation</span><span className="font-semibold tabular-nums">₹{selected.coinCompensationTotal.toLocaleString("en-IN")}</span></div>
                <div className="flex justify-between text-sm"><span className="text-muted-foreground">Coin Comp. Status</span><Badge variant={selected.coinCompStatus === "PAID" ? "default" : "secondary"} className={selected.coinCompStatus === "PAID" ? "bg-[hsl(170,60%,42%)]" : ""}>{selected.coinCompStatus}</Badge></div>
              </div>
              {(selected.commissionStatus === "PENDING" || selected.coinCompStatus === "PENDING") && (
                <div className="flex gap-2 pt-2">
                  {selected.commissionStatus === "PENDING" && (
                     <Button className="flex-1 rounded-lg" disabled={markPaidMutation.isPending} onClick={() => handleMarkPaid(selected.id, { commissionPaid: true })}>
                       Mark Commission Paid
                     </Button>
                  )}
                  {selected.coinCompStatus === "PENDING" && (
                     <Button variant="outline" className="flex-1 rounded-lg" disabled={markPaidMutation.isPending} onClick={() => handleMarkPaid(selected.id, { coinCompPaid: true })}>
                       Mark Coin Comp. Paid
                     </Button>
                  )}
                </div>
              )}
            </div>
          )}
        </SheetContent>
      </Sheet>
    </div>
  );
}

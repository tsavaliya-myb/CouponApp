import { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from "@/components/ui/sheet";
import { CreditCard, RefreshCw, CheckCircle2, XCircle, Clock, Loader2 } from "lucide-react";
import { usePayments } from "@/hooks/api/usePayments";
import { PaymentAttempt } from "@/types/api/payments";
import { format } from "date-fns";

const statusStyles: Record<string, string> = {
  SUCCESS: "bg-[hsl(145,50%,95%)] text-[hsl(170,60%,35%)] border-0 font-medium",
  PENDING: "bg-[hsl(45,90%,95%)] text-[hsl(38,80%,40%)] border-0 font-medium",
  FAILED: "bg-[hsl(340,50%,96%)] text-[hsl(340,65%,45%)] border-0 font-medium",
  CANCELLED: "bg-muted text-muted-foreground border-0 font-medium",
};

export default function PaymentsPage() {
  const [statusFilter, setStatusFilter] = useState("all");
  const [kindFilter, setKindFilter] = useState("all");
  const [selected, setSelected] = useState<PaymentAttempt | null>(null);

  const { data, isLoading, isError } = usePayments({
    page: 1,
    limit: 50,
    status: statusFilter !== "all" ? (statusFilter as any) : undefined,
    kind: kindFilter !== "all" ? (kindFilter as any) : undefined,
  });

  const attempts = data?.data || [];
  const meta = data?.meta;
  const totalCount = meta?.total || 0;
  const successCount = attempts.filter((a) => a.status === "SUCCESS").length;
  const failedCount = attempts.filter((a) => a.status === "FAILED").length;
  const pendingCount = attempts.filter((a) => a.status === "PENDING").length;

  return (
    <div className="space-y-6">
      <div className="animate-in-view">
        <h1 className="text-2xl md:text-3xl font-bold tracking-tight">Payments</h1>
        <p className="text-muted-foreground mt-1">
          Razorpay UPI Autopay mandate registrations and renewal debits — {totalCount} attempts on this page
        </p>
      </div>

      {/* Summary cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 animate-in-view" style={{ animationDelay: "60ms" }}>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2 rounded-lg bg-[hsl(250,55%,96%)]">
              <CreditCard className="h-4 w-4 text-[hsl(250,60%,52%)]" />
            </div>
            <div>
              <p className="text-2xl font-bold tabular-nums">{totalCount}</p>
              <p className="text-xs text-muted-foreground">Total</p>
            </div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2 rounded-lg bg-[hsl(145,50%,95%)]">
              <CheckCircle2 className="h-4 w-4 text-[hsl(170,60%,42%)]" />
            </div>
            <div>
              <p className="text-2xl font-bold tabular-nums">{successCount}</p>
              <p className="text-xs text-muted-foreground">Success</p>
            </div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2 rounded-lg bg-[hsl(45,90%,95%)]">
              <Clock className="h-4 w-4 text-[hsl(38,80%,45%)]" />
            </div>
            <div>
              <p className="text-2xl font-bold tabular-nums">{pendingCount}</p>
              <p className="text-xs text-muted-foreground">Pending</p>
            </div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2 rounded-lg bg-[hsl(340,50%,96%)]">
              <XCircle className="h-4 w-4 text-[hsl(340,65%,52%)]" />
            </div>
            <div>
              <p className="text-2xl font-bold tabular-nums">{failedCount}</p>
              <p className="text-xs text-muted-foreground">Failed</p>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <div className="flex flex-wrap gap-3 animate-in-view" style={{ animationDelay: "120ms" }}>
        <Select value={statusFilter} onValueChange={setStatusFilter}>
          <SelectTrigger className="w-40 rounded-lg h-10"><SelectValue placeholder="Status" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Status</SelectItem>
            <SelectItem value="PENDING">Pending</SelectItem>
            <SelectItem value="SUCCESS">Success</SelectItem>
            <SelectItem value="FAILED">Failed</SelectItem>
            <SelectItem value="CANCELLED">Cancelled</SelectItem>
          </SelectContent>
        </Select>
        <Select value={kindFilter} onValueChange={setKindFilter}>
          <SelectTrigger className="w-40 rounded-lg h-10"><SelectValue placeholder="Kind" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Kinds</SelectItem>
            <SelectItem value="MANDATE">New Setup</SelectItem>
            <SelectItem value="RENEWAL">Renewal</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {/* Table */}
      <Card className="border-0 shadow-sm overflow-hidden animate-in-view" style={{ animationDelay: "180ms" }}>
        <Table>
          <TableHeader>
            <TableRow className="hover:bg-transparent">
              <TableHead className="font-semibold text-foreground">User</TableHead>
              <TableHead className="hidden md:table-cell font-semibold text-foreground">Kind</TableHead>
              <TableHead className="font-semibold text-foreground">Status</TableHead>
              <TableHead className="text-right font-semibold text-foreground">Amount</TableHead>
              <TableHead className="hidden lg:table-cell font-semibold text-foreground">Order ID</TableHead>
              <TableHead className="hidden md:table-cell font-semibold text-foreground">Created</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {isLoading && (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-12">
                  <Loader2 className="mx-auto h-8 w-8 animate-spin text-muted-foreground" />
                </TableCell>
              </TableRow>
            )}

            {isError && (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-12 text-destructive font-medium border border-destructive/20 bg-destructive/5 rounded-xl">
                  Failed to fetch payment attempts. Please try again.
                </TableCell>
              </TableRow>
            )}

            {!isLoading && !isError && attempts.map((a) => (
              <TableRow key={a.id} className="cursor-pointer hover:bg-accent/50 transition-colors" onClick={() => setSelected(a)}>
                <TableCell className="font-medium">
                  {a.user?.name || "-"}
                  <div className="text-xs text-muted-foreground tabular-nums">{a.user?.phone}</div>
                </TableCell>
                <TableCell className="hidden md:table-cell text-muted-foreground">
                  <span className="inline-flex items-center gap-1">
                    {a.kind === "RENEWAL" && <RefreshCw className="h-3 w-3" />}
                    {a.kind === "MANDATE" ? "New Setup" : "Renewal"}
                  </span>
                </TableCell>
                <TableCell>
                  <Badge variant="secondary" className={statusStyles[a.status] || "bg-muted text-muted-foreground border-0 font-medium"}>
                    {a.status}
                  </Badge>
                </TableCell>
                <TableCell className="text-right tabular-nums font-medium">₹{a.amount}</TableCell>
                <TableCell className="hidden lg:table-cell text-muted-foreground font-mono text-xs">{a.razorpayOrderId}</TableCell>
                <TableCell className="hidden md:table-cell text-muted-foreground">
                  {format(new Date(a.createdAt), "dd MMM, yyyy h:mm a")}
                </TableCell>
              </TableRow>
            ))}
            {!isLoading && !isError && attempts.length === 0 && (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-12 text-muted-foreground">No payment attempts found</TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </Card>

      {/* Detail Sheet */}
      <Sheet open={!!selected} onOpenChange={(open) => !open && setSelected(null)}>
        <SheetContent className="sm:max-w-lg overflow-y-auto">
          {selected && (
            <>
              <SheetHeader>
                <SheetTitle className="text-xl">
                  {selected.kind === "MANDATE" ? "Mandate Registration" : "Renewal Debit"}
                </SheetTitle>
                <SheetDescription>{selected.user?.name || "-"} · {selected.user?.phone}</SheetDescription>
              </SheetHeader>
              <div className="mt-5 space-y-3 text-sm">
                <div className="grid grid-cols-2 gap-3">
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Status</p>
                    <p className="font-semibold mt-0.5">{selected.status}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Amount</p>
                    <p className="font-semibold tabular-nums mt-0.5">₹{selected.amount}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5 col-span-2">
                    <p className="text-muted-foreground text-xs font-medium">Razorpay Order ID</p>
                    <p className="font-semibold mt-0.5 font-mono text-xs break-all">{selected.razorpayOrderId}</p>
                  </div>
                  {selected.razorpayPaymentId && (
                    <div className="rounded-xl bg-muted/50 p-3.5 col-span-2">
                      <p className="text-muted-foreground text-xs font-medium">Razorpay Payment ID</p>
                      <p className="font-semibold mt-0.5 font-mono text-xs break-all">{selected.razorpayPaymentId}</p>
                    </div>
                  )}
                  {selected.razorpayTokenId && (
                    <div className="rounded-xl bg-muted/50 p-3.5 col-span-2">
                      <p className="text-muted-foreground text-xs font-medium">Mandate Token ID</p>
                      <p className="font-semibold mt-0.5 font-mono text-xs break-all">{selected.razorpayTokenId}</p>
                    </div>
                  )}
                  {(selected.errorCode || selected.errorDescription) && (
                    <div className="rounded-xl bg-destructive/5 border border-destructive/20 p-3.5 col-span-2">
                      <p className="text-destructive text-xs font-medium">Error</p>
                      <p className="font-semibold mt-0.5 text-destructive">{selected.errorCode}</p>
                      <p className="text-muted-foreground text-xs mt-1">{selected.errorDescription}</p>
                    </div>
                  )}
                  <div className="rounded-xl bg-muted/50 p-3.5 col-span-2">
                    <p className="text-muted-foreground text-xs font-medium">Created</p>
                    <p className="font-semibold mt-0.5">{format(new Date(selected.createdAt), "dd MMM, yyyy h:mm a")}</p>
                  </div>
                </div>
              </div>
            </>
          )}
        </SheetContent>
      </Sheet>
    </div>
  );
}

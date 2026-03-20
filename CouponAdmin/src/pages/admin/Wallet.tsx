import { useState } from "react";
import { mockCoinTransactions, mockUsers, appSettings } from "@/data/mock-data";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Coins, Settings2, ArrowUpCircle, ArrowDownCircle, Gift, AlertCircle } from "lucide-react";

export default function WalletPage() {
  const [typeFilter, setTypeFilter] = useState("all");
  const [bulkOpen, setBulkOpen] = useState(false);
  const [bulkAmount, setBulkAmount] = useState("");

  const totalEarned = mockCoinTransactions.filter((t) => t.type === "earned").reduce((a, t) => a + t.amount, 0);
  const totalUsed = mockCoinTransactions.filter((t) => t.type === "used").reduce((a, t) => a + t.amount, 0);
  const totalLiability = mockUsers.reduce((a, u) => a + u.coinBalance, 0);

  const filtered = mockCoinTransactions.filter((t) => {
    if (typeFilter !== "all" && t.type !== typeFilter) return false;
    return true;
  });

  return (
    <div className="space-y-6">
      <div className="animate-in-view">
        <h1 className="text-2xl md:text-3xl font-bold tracking-tight">Wallet Management</h1>
        <p className="text-muted-foreground mt-1">Manage coin settings, transactions, and platform-wide coin operations.</p>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 animate-in-view" style={{ animationDelay: "60ms" }}>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2.5 rounded-xl bg-[hsl(170,60%,42%)] text-white"><ArrowUpCircle className="h-4 w-4" /></div>
            <div><p className="text-2xl font-bold tabular-nums">{totalEarned}</p><p className="text-xs text-muted-foreground font-medium">Total Coins Awarded</p></div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2.5 rounded-xl bg-[hsl(340,65%,52%)] text-white"><ArrowDownCircle className="h-4 w-4" /></div>
            <div><p className="text-2xl font-bold tabular-nums">{totalUsed}</p><p className="text-xs text-muted-foreground font-medium">Total Coins Used</p></div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2.5 rounded-xl bg-[hsl(35,92%,52%)] text-white"><AlertCircle className="h-4 w-4" /></div>
            <div><p className="text-2xl font-bold tabular-nums">₹{totalLiability}</p><p className="text-xs text-muted-foreground font-medium">Outstanding Liability</p></div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2.5 rounded-xl bg-[hsl(250,60%,52%)] text-white"><Settings2 className="h-4 w-4" /></div>
            <div><p className="text-2xl font-bold tabular-nums">{appSettings.coinsPerSubscription}</p><p className="text-xs text-muted-foreground font-medium">Coins / Subscription</p></div>
          </CardContent>
        </Card>
      </div>

      {/* Coin Settings Card */}
      <Card className="border-0 shadow-sm animate-in-view" style={{ animationDelay: "120ms" }}>
        <CardHeader className="pb-3">
          <CardTitle className="text-sm font-semibold flex items-center gap-2"><Settings2 className="h-4 w-4" /> Coin Settings</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid sm:grid-cols-2 gap-4">
            <div>
              <Label className="text-xs text-muted-foreground">Coins per Subscription</Label>
              <Input type="number" defaultValue={appSettings.coinsPerSubscription} className="mt-1 rounded-lg" />
            </div>
            <div>
              <Label className="text-xs text-muted-foreground">Max Coins per Transaction</Label>
              <Input type="number" defaultValue={appSettings.maxCoinsPerTransaction} className="mt-1 rounded-lg" />
            </div>
          </div>
          <div className="flex gap-2 mt-4">
            <Button className="rounded-lg">Save Settings</Button>
            <Button variant="outline" className="rounded-lg" onClick={() => setBulkOpen(true)}>
              <Gift className="h-4 w-4 mr-1.5" /> Bulk Award Coins
            </Button>
          </div>
        </CardContent>
      </Card>

      {/* Filters + Table */}
      <div className="flex gap-3 animate-in-view" style={{ animationDelay: "180ms" }}>
        <Select value={typeFilter} onValueChange={setTypeFilter}>
          <SelectTrigger className="w-40 rounded-lg"><SelectValue placeholder="Type" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Types</SelectItem>
            <SelectItem value="earned">Earned</SelectItem>
            <SelectItem value="used">Used</SelectItem>
          </SelectContent>
        </Select>
      </div>

      <Card className="border-0 shadow-sm animate-in-view" style={{ animationDelay: "240ms" }}>
        <Table>
          <TableHeader>
            <TableRow className="bg-muted/30">
              <TableHead>User</TableHead>
              <TableHead>Type</TableHead>
              <TableHead className="text-right">Amount</TableHead>
              <TableHead>Context</TableHead>
              <TableHead>Date</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {filtered.map((t) => (
              <TableRow key={t.id}>
                <TableCell className="font-medium">{t.userName}</TableCell>
                <TableCell>
                  <Badge className={t.type === "earned" ? "bg-[hsl(170,50%,95%)] text-[hsl(170,60%,32%)] hover:bg-[hsl(170,50%,90%)]" : "bg-[hsl(340,50%,95%)] text-[hsl(340,65%,42%)] hover:bg-[hsl(340,50%,90%)]"}>
                    {t.type === "earned" ? "Earned" : "Used"}
                  </Badge>
                </TableCell>
                <TableCell className="text-right tabular-nums font-medium">{t.type === "earned" ? "+" : "-"}{t.amount}</TableCell>
                <TableCell className="text-muted-foreground text-sm">{t.context}</TableCell>
                <TableCell className="text-muted-foreground text-sm">{t.date}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </Card>

      {/* Bulk Award Dialog */}
      <Dialog open={bulkOpen} onOpenChange={setBulkOpen}>
        <DialogContent className="rounded-2xl">
          <DialogHeader><DialogTitle>Bulk Award Coins</DialogTitle></DialogHeader>
          <div className="space-y-4 py-2">
            <div>
              <Label className="text-xs text-muted-foreground">Audience</Label>
              <Select defaultValue="all">
                <SelectTrigger className="rounded-lg mt-1"><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All Users</SelectItem>
                  <SelectItem value="surat">Surat Users</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div>
              <Label className="text-xs text-muted-foreground">Coins per User</Label>
              <Input type="number" value={bulkAmount} onChange={(e) => setBulkAmount(e.target.value)} placeholder="e.g. 10" className="rounded-lg mt-1" />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setBulkOpen(false)} className="rounded-lg">Cancel</Button>
            <Button className="rounded-lg" onClick={() => setBulkOpen(false)}>Award to All</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}

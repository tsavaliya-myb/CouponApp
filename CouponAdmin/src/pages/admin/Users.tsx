import { useState } from "react";
import { mockUsers, mockRedemptions, mockCoinTransactions, cities, areasByCity, type User } from "@/data/mock-data";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from "@/components/ui/sheet";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Card, CardContent } from "@/components/ui/card";
import { Search, Coins, Ban, ShieldCheck, Users as UsersIcon } from "lucide-react";

export default function UsersPage() {
  const [search, setSearch] = useState("");
  const [cityFilter, setCityFilter] = useState("all");
  const [areaFilter, setAreaFilter] = useState("all");
  const [statusFilter, setStatusFilter] = useState("all");
  const [selectedUser, setSelectedUser] = useState<User | null>(null);
  const [awardOpen, setAwardOpen] = useState(false);
  const [awardUser, setAwardUser] = useState<User | null>(null);
  const [awardAmount, setAwardAmount] = useState("");
  const [awardNote, setAwardNote] = useState("");

  const areas = cityFilter !== "all" ? areasByCity[cityFilter] || [] : [];

  const filtered = mockUsers.filter((u) => {
    if (search && !u.name.toLowerCase().includes(search.toLowerCase()) && !u.phone.includes(search)) return false;
    if (cityFilter !== "all" && u.city !== cityFilter) return false;
    if (areaFilter !== "all" && u.area !== areaFilter) return false;
    if (statusFilter !== "all" && u.status !== statusFilter) return false;
    return true;
  });

  const userRedemptions = selectedUser ? mockRedemptions.filter((r) => r.userId === selectedUser.id) : [];
  const userCoins = selectedUser ? mockCoinTransactions.filter((c) => c.userId === selectedUser.id) : [];

  const activeCount = mockUsers.filter((u) => u.status === "active").length;
  const expiredCount = mockUsers.filter((u) => u.status === "expired").length;

  return (
    <div className="space-y-6">
      <div className="animate-in-view">
        <h1 className="text-2xl md:text-3xl font-bold tracking-tight">User Management</h1>
        <p className="text-muted-foreground mt-1">{mockUsers.length} registered users</p>
      </div>

      {/* Summary cards */}
      <div className="grid grid-cols-3 gap-4 animate-in-view" style={{ animationDelay: "60ms" }}>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2 rounded-lg bg-[hsl(250,55%,96%)]">
              <UsersIcon className="h-4 w-4 text-[hsl(250,60%,52%)]" />
            </div>
            <div>
              <p className="text-2xl font-bold tabular-nums">{mockUsers.length}</p>
              <p className="text-xs text-muted-foreground">Total</p>
            </div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2 rounded-lg bg-[hsl(145,50%,95%)]">
              <ShieldCheck className="h-4 w-4 text-[hsl(170,60%,42%)]" />
            </div>
            <div>
              <p className="text-2xl font-bold tabular-nums">{activeCount}</p>
              <p className="text-xs text-muted-foreground">Active</p>
            </div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2 rounded-lg bg-[hsl(340,50%,96%)]">
              <Ban className="h-4 w-4 text-[hsl(340,65%,52%)]" />
            </div>
            <div>
              <p className="text-2xl font-bold tabular-nums">{expiredCount}</p>
              <p className="text-xs text-muted-foreground">Expired</p>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <div className="flex flex-wrap gap-3 animate-in-view" style={{ animationDelay: "120ms" }}>
        <div className="relative w-64">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input placeholder="Search name or phone…" className="pl-9 rounded-lg h-10" value={search} onChange={(e) => setSearch(e.target.value)} />
        </div>
        <Select value={cityFilter} onValueChange={(v) => { setCityFilter(v); setAreaFilter("all"); }}>
          <SelectTrigger className="w-36 rounded-lg h-10"><SelectValue placeholder="City" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Cities</SelectItem>
            {cities.map((c) => <SelectItem key={c} value={c}>{c}</SelectItem>)}
          </SelectContent>
        </Select>
        <Select value={areaFilter} onValueChange={setAreaFilter} disabled={cityFilter === "all"}>
          <SelectTrigger className="w-36 rounded-lg h-10"><SelectValue placeholder="Area" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Areas</SelectItem>
            {areas.map((a) => <SelectItem key={a} value={a}>{a}</SelectItem>)}
          </SelectContent>
        </Select>
        <Select value={statusFilter} onValueChange={setStatusFilter}>
          <SelectTrigger className="w-36 rounded-lg h-10"><SelectValue placeholder="Status" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Status</SelectItem>
            <SelectItem value="active">Active</SelectItem>
            <SelectItem value="expired">Expired</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {/* Table */}
      <Card className="border-0 shadow-sm overflow-hidden animate-in-view" style={{ animationDelay: "180ms" }}>
        <Table>
          <TableHeader>
            <TableRow className="bg-muted/50 hover:bg-muted/50">
              <TableHead className="font-semibold">Name</TableHead>
              <TableHead className="hidden md:table-cell font-semibold">Phone</TableHead>
              <TableHead className="hidden lg:table-cell font-semibold">City</TableHead>
              <TableHead className="hidden lg:table-cell font-semibold">Area</TableHead>
              <TableHead className="font-semibold">Status</TableHead>
              <TableHead className="hidden md:table-cell font-semibold">Joined</TableHead>
              <TableHead className="text-right font-semibold">Coins</TableHead>
              <TableHead className="text-right font-semibold">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {filtered.map((u) => (
              <TableRow key={u.id} className="cursor-pointer hover:bg-accent/50 transition-colors" onClick={() => setSelectedUser(u)}>
                <TableCell className="font-medium">{u.name}</TableCell>
                <TableCell className="hidden md:table-cell tabular-nums text-muted-foreground">{u.phone}</TableCell>
                <TableCell className="hidden lg:table-cell text-muted-foreground">{u.city}</TableCell>
                <TableCell className="hidden lg:table-cell text-muted-foreground">{u.area}</TableCell>
                <TableCell>
                  <Badge variant="secondary" className={
                    u.status === "active"
                      ? "bg-[hsl(145,50%,95%)] text-[hsl(170,60%,35%)] border-0 font-medium"
                      : "bg-muted text-muted-foreground border-0 font-medium"
                  }>
                    {u.status}
                  </Badge>
                </TableCell>
                <TableCell className="hidden md:table-cell text-muted-foreground">{u.joinDate}</TableCell>
                <TableCell className="text-right tabular-nums font-medium">{u.coinBalance}</TableCell>
                <TableCell className="text-right">
                  <div className="flex justify-end gap-1" onClick={(e) => e.stopPropagation()}>
                    <Button size="icon" variant="ghost" className="h-8 w-8 rounded-lg hover:bg-accent" title="Award coins" onClick={() => { setAwardUser(u); setAwardOpen(true); }}>
                      <Coins className="h-4 w-4" />
                    </Button>
                    <Button size="icon" variant="ghost" className="h-8 w-8 rounded-lg hover:bg-accent" title={u.status === "active" ? "Block" : "Unblock"}>
                      {u.status === "active" ? <Ban className="h-4 w-4" /> : <ShieldCheck className="h-4 w-4" />}
                    </Button>
                  </div>
                </TableCell>
              </TableRow>
            ))}
            {filtered.length === 0 && (
              <TableRow>
                <TableCell colSpan={8} className="text-center py-12 text-muted-foreground">No users found</TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </Card>

      {/* User Detail Sheet */}
      <Sheet open={!!selectedUser} onOpenChange={(open) => !open && setSelectedUser(null)}>
        <SheetContent className="sm:max-w-lg overflow-y-auto">
          {selectedUser && (
            <>
              <SheetHeader>
                <SheetTitle className="text-xl">{selectedUser.name}</SheetTitle>
                <SheetDescription>{selectedUser.phone} · {selectedUser.city}, {selectedUser.area}</SheetDescription>
              </SheetHeader>
              <div className="mt-5 space-y-3 text-sm">
                <div className="grid grid-cols-2 gap-3">
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Status</p>
                    <p className="font-semibold capitalize mt-0.5">{selectedUser.status}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Coin Balance</p>
                    <p className="font-semibold tabular-nums mt-0.5">{selectedUser.coinBalance}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Joined</p>
                    <p className="font-semibold mt-0.5">{selectedUser.joinDate}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Expires</p>
                    <p className="font-semibold mt-0.5">{selectedUser.subscriptionExpiry}</p>
                  </div>
                </div>
              </div>

              <Tabs defaultValue="redemptions" className="mt-6">
                <TabsList className="w-full rounded-lg">
                  <TabsTrigger value="redemptions" className="flex-1 rounded-md">Redemptions</TabsTrigger>
                  <TabsTrigger value="coins" className="flex-1 rounded-md">Coin Ledger</TabsTrigger>
                </TabsList>
                <TabsContent value="redemptions" className="mt-3 space-y-2">
                  {userRedemptions.length === 0 && <p className="text-muted-foreground text-sm py-8 text-center">No redemptions yet</p>}
                  {userRedemptions.map((r) => (
                    <div key={r.id} className="rounded-xl bg-muted/40 p-3.5 text-sm">
                      <div className="flex justify-between">
                        <span className="font-semibold">{r.couponName}</span>
                        <span className="text-muted-foreground text-xs">{r.date}</span>
                      </div>
                      <p className="text-muted-foreground mt-1">
                        {r.sellerName} · Bill ₹{r.billAmount} → ₹{r.finalAmount}
                        {r.coinsUsed > 0 && ` · ${r.coinsUsed} coins used`}
                      </p>
                    </div>
                  ))}
                </TabsContent>
                <TabsContent value="coins" className="mt-3 space-y-2">
                  {userCoins.length === 0 && <p className="text-muted-foreground text-sm py-8 text-center">No coin transactions</p>}
                  {userCoins.map((c) => (
                    <div key={c.id} className="rounded-xl bg-muted/40 p-3.5 text-sm flex justify-between items-center">
                      <div>
                        <p className="font-semibold">{c.context}</p>
                        <p className="text-muted-foreground text-xs mt-0.5">{c.date}</p>
                      </div>
                      <span className={`font-bold tabular-nums ${c.type === "earned" ? "text-[hsl(170,60%,42%)]" : "text-[hsl(0,72%,51%)]"}`}>
                        {c.type === "earned" ? "+" : "-"}{c.amount}
                      </span>
                    </div>
                  ))}
                </TabsContent>
              </Tabs>
            </>
          )}
        </SheetContent>
      </Sheet>

      {/* Award Coins Dialog */}
      <Dialog open={awardOpen} onOpenChange={setAwardOpen}>
        <DialogContent className="rounded-xl">
          <DialogHeader>
            <DialogTitle>Award Coins to {awardUser?.name}</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 py-2">
            <div>
              <Label className="text-sm font-medium">Amount</Label>
              <Input type="number" placeholder="e.g. 50" value={awardAmount} onChange={(e) => setAwardAmount(e.target.value)} className="mt-1.5 rounded-lg" />
            </div>
            <div>
              <Label className="text-sm font-medium">Note (optional)</Label>
              <Textarea placeholder="e.g. Welcome bonus" value={awardNote} onChange={(e) => setAwardNote(e.target.value)} className="mt-1.5 rounded-lg" />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setAwardOpen(false)} className="rounded-lg">Cancel</Button>
            <Button onClick={() => { setAwardOpen(false); setAwardAmount(""); setAwardNote(""); }} className="rounded-lg">Award Coins</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}

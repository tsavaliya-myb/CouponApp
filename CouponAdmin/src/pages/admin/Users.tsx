import { useState, useEffect } from "react";
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
import { Search, Coins, Ban, ShieldCheck, Users as UsersIcon, Loader2 } from "lucide-react";
import { useUsers, useUserDetail, useBlockUser, useUnblockUser } from "@/hooks/api/useUsers";
import { useCities, useAreas } from "@/hooks/api/useLocation";
import { User, UserRedemption, UserWalletTransaction } from "@/types/api/users";
import { format } from "date-fns";
import { toast } from "sonner";

export default function UsersPage() {
  const [search, setSearch] = useState("");
  const [debouncedSearch, setDebouncedSearch] = useState("");
  const [cityFilter, setCityFilter] = useState("all");
  const [areaFilter, setAreaFilter] = useState("all");
  const [statusFilter, setStatusFilter] = useState("all");
  const [selectedUser, setSelectedUser] = useState<User | null>(null);
  const [awardOpen, setAwardOpen] = useState(false);
  const [awardUser, setAwardUser] = useState<User | null>(null);
  const [awardAmount, setAwardAmount] = useState("");
  const [awardNote, setAwardNote] = useState("");

  const blockMutation = useBlockUser();
  const unblockMutation = useUnblockUser();

  useEffect(() => {
    const handler = setTimeout(() => setDebouncedSearch(search), 400);
    return () => clearTimeout(handler);
  }, [search]);

  const { data: citiesData, isLoading: isCitiesLoading } = useCities();
  const apiCities = citiesData?.data || [];

  const { data: areasData, isLoading: isAreasLoading } = useAreas(cityFilter !== "all" ? cityFilter : null);
  const apiAreas = areasData?.data || [];

  const { data, isLoading, isError } = useUsers({
    page: 1,
    limit: 50,
    search: debouncedSearch || undefined,
    status: statusFilter !== "all" ? statusFilter : undefined,
    cityId: cityFilter !== "all" ? cityFilter : undefined,
    areaId: areaFilter !== "all" ? areaFilter : undefined,
  });

  const users = data?.data || [];
  const meta = data?.meta;

  const { data: userDetailData, isLoading: isUserDetailLoading } = useUserDetail(selectedUser?.id || null);
  const userFullDetails = userDetailData?.data;

  const userRedemptions: UserRedemption[] = userFullDetails?.redemptions || [];
  const userCoins: UserWalletTransaction[] = userFullDetails?.wallet || [];

  const totalCount = meta?.total || 0;
  // Fallback calculations for visible UI approximations
  const activeCount = users.filter((u) => u.status === "ACTIVE").length;
  const expiredCount = users.filter((u) => u.status === "EXPIRED" || u.status === "INACTIVE").length;

  return (
    <div className="space-y-6">
      <div className="animate-in-view">
        <h1 className="text-2xl md:text-3xl font-bold tracking-tight">User Management</h1>
        <p className="text-muted-foreground mt-1">{totalCount} registered users</p>
      </div>

      {/* Summary cards */}
      <div className="grid grid-cols-3 gap-4 animate-in-view" style={{ animationDelay: "60ms" }}>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2 rounded-lg bg-[hsl(250,55%,96%)]">
              <UsersIcon className="h-4 w-4 text-[hsl(250,60%,52%)]" />
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
        <Select value={cityFilter} onValueChange={(val) => { setCityFilter(val); setAreaFilter("all"); }}>
          <SelectTrigger className="w-36 rounded-lg h-10"><SelectValue placeholder={isCitiesLoading ? "Loading..." : "City"} /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Cities</SelectItem>
            {apiCities.map(c => <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>)}
          </SelectContent>
        </Select>

        <Select value={areaFilter} onValueChange={setAreaFilter} disabled={cityFilter === "all" || isAreasLoading}>
          <SelectTrigger className="w-36 rounded-lg h-10"><SelectValue placeholder={isAreasLoading ? "Loading..." : "Area"} /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Areas</SelectItem>
            {apiAreas.map(a => <SelectItem key={a.id} value={a.id}>{a.name}</SelectItem>)}
          </SelectContent>
        </Select>
        <Select value={statusFilter} onValueChange={setStatusFilter}>
          <SelectTrigger className="w-36 rounded-lg h-10"><SelectValue placeholder="Status" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Status</SelectItem>
            <SelectItem value="ACTIVE">Active</SelectItem>
            <SelectItem value="EXPIRED">Expired</SelectItem>
            <SelectItem value="BANNED">Banned</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {/* Table */}
      <Card className="border-0 shadow-sm overflow-hidden animate-in-view" style={{ animationDelay: "180ms" }}>
        <Table>
          <TableHeader>
            <TableRow className="hover:bg-transparent">
              <TableHead className="font-semibold text-foreground">Name</TableHead>
              <TableHead className="hidden md:table-cell font-semibold text-foreground">Phone</TableHead>
              <TableHead className="hidden lg:table-cell font-semibold text-foreground">City</TableHead>
              <TableHead className="hidden lg:table-cell font-semibold text-foreground">Area</TableHead>
              <TableHead className="font-semibold text-foreground">Status</TableHead>
              <TableHead className="hidden md:table-cell font-semibold text-foreground">Joined</TableHead>
              <TableHead className="text-right font-semibold text-foreground">Coins</TableHead>
              <TableHead className="w-[100px]"></TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {isLoading && (
              <TableRow>
                <TableCell colSpan={8} className="text-center py-12">
                   <Loader2 className="mx-auto h-8 w-8 animate-spin text-muted-foreground" />
                </TableCell>
              </TableRow>
            )}
            
            {isError && (
              <TableRow>
                <TableCell colSpan={8} className="text-center py-12 text-destructive font-medium border border-destructive/20 bg-destructive/5 rounded-xl">
                   Failed to fetch user directory. Please try again.
                </TableCell>
              </TableRow>
            )}

            {!isLoading && !isError && users.map((u) => (
              <TableRow key={u.id} className="cursor-pointer hover:bg-accent/50 transition-colors" onClick={() => setSelectedUser(u)}>
                <TableCell className="font-medium">{u.name}</TableCell>
                <TableCell className="hidden md:table-cell tabular-nums text-muted-foreground">{u.phone}</TableCell>
                <TableCell className="hidden lg:table-cell text-muted-foreground capitalize">{u.city?.name || "-"}</TableCell>
                <TableCell className="hidden lg:table-cell text-muted-foreground capitalize">{u.area?.name || "-"}</TableCell>
                <TableCell>
                  <Badge variant="secondary" className={
                    u.status === "ACTIVE"
                      ? "bg-[hsl(145,50%,95%)] text-[hsl(170,60%,35%)] border-0 font-medium"
                      : "bg-muted text-muted-foreground border-0 font-medium"
                  }>
                    {u.status}
                  </Badge>
                </TableCell>
                <TableCell className="hidden md:table-cell text-muted-foreground">
                  {format(new Date(u.createdAt), "dd MMM, yyyy")}
                </TableCell>
                <TableCell className="text-right tabular-nums font-medium">{u.coinBalance}</TableCell>
                <TableCell className="text-right">
                  <div className="flex justify-end gap-1" onClick={(e) => e.stopPropagation()}>
                    <Button size="icon" variant="ghost" className="h-8 w-8 rounded-lg hover:bg-accent" title="Award coins" onClick={() => { setAwardUser(u); setAwardOpen(true); }}>
                      <Coins className="h-4 w-4" />
                    </Button>
                    <Button 
                      size="icon" 
                      variant="ghost" 
                      className="h-8 w-8 rounded-lg hover:bg-accent" 
                      title={u.status === "ACTIVE" ? "Block User" : "Unblock User"}
                      disabled={blockMutation.isPending || unblockMutation.isPending}
                      onClick={(e) => {
                        e.stopPropagation();
                        if (u.status === "ACTIVE") {
                          blockMutation.mutate(u.id, {
                            onSuccess: () => toast.success(`Blocked user ${u.name}`),
                            onError: (err: any) => toast.error(err.response?.data?.message || "Failed to block user"),
                          });
                        } else {
                          unblockMutation.mutate(u.id, {
                            onSuccess: () => toast.success(`Unblocked user ${u.name}`),
                            onError: (err: any) => toast.error(err.response?.data?.message || "Failed to unblock user"),
                          });
                        }
                      }}
                    >
                      {blockMutation.isPending && u.id === blockMutation.variables ? (
                        <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />
                      ) : unblockMutation.isPending && u.id === unblockMutation.variables ? (
                        <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />
                      ) : u.status === "ACTIVE" ? (
                        <Ban className="h-4 w-4 text-muted-foreground hover:text-destructive transition-colors" />
                      ) : (
                        <ShieldCheck className="h-4 w-4 text-muted-foreground hover:text-primary transition-colors" />
                      )}
                    </Button>
                  </div>
                </TableCell>
              </TableRow>
            ))}
            {!isLoading && !isError && users.length === 0 && (
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
                <SheetDescription>{selectedUser.phone} · {selectedUser.city?.name || "No City"}, {selectedUser.area?.name || ""}</SheetDescription>
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
                    <p className="font-semibold mt-0.5">{format(new Date(selectedUser.createdAt), "dd MMM, yyyy")}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Last Active</p>
                    <p className="font-semibold mt-0.5">{format(new Date(selectedUser.updatedAt), "dd MMM, yyyy")}</p>
                  </div>
                </div>
              </div>

              <Tabs defaultValue="redemptions" className="mt-6">
                <TabsList className="w-full rounded-lg">
                  <TabsTrigger value="redemptions" className="flex-1 rounded-md">Redemptions</TabsTrigger>
                  <TabsTrigger value="coins" className="flex-1 rounded-md">Coin Ledger</TabsTrigger>
                </TabsList>
                <TabsContent value="redemptions" className="mt-3 space-y-2">
                  {isUserDetailLoading && <div className="py-8 flex justify-center"><Loader2 className="animate-spin text-muted-foreground w-6 h-6" /></div>}
                  {!isUserDetailLoading && userRedemptions.length === 0 && <p className="text-muted-foreground text-sm py-8 text-center">No redemptions yet</p>}
                  {!isUserDetailLoading && userRedemptions.map((r) => (
                    <div key={r.id} className="rounded-xl bg-muted/40 p-3.5 text-sm">
                      <div className="flex justify-between">
                        <span className="font-semibold">{r.userCoupon?.coupon?.type || "Standard Coupon"}</span>
                        <span className="text-muted-foreground text-xs">{format(new Date(r.redeemedAt), "dd MMM, yyyy")}</span>
                      </div>
                      <p className="text-muted-foreground mt-1">
                        {r.seller?.businessName || "-"} · Bill ₹{r.billAmount} → ₹{r.finalAmount}
                        {r.coinsUsed > 0 && ` · ${r.coinsUsed} coins used`}
                      </p>
                    </div>
                  ))}
                </TabsContent>
                <TabsContent value="coins" className="mt-3 space-y-2">
                  {isUserDetailLoading && <div className="py-8 flex justify-center"><Loader2 className="animate-spin text-muted-foreground w-6 h-6" /></div>}
                  {!isUserDetailLoading && userCoins.length === 0 && <p className="text-muted-foreground text-sm py-8 text-center">No coin transactions</p>}
                  {!isUserDetailLoading && userCoins.map((c) => (
                    <div key={c.id} className="rounded-xl bg-muted/40 p-3.5 text-sm flex justify-between items-center">
                      <div>
                        <p className="font-semibold">{c.note || (c.type === "EARNED" ? "Awarded" : "Deducted")}</p>
                        <p className="text-muted-foreground text-xs mt-0.5">{format(new Date(c.createdAt), "dd MMM, yyyy h:mm a")}</p>
                      </div>
                      <span className={`font-bold tabular-nums ${c.type === "EARNED" ? "text-[hsl(170,60%,42%)]" : "text-[hsl(0,72%,51%)]"}`}>
                        {c.type === "EARNED" ? "+" : "-"}{c.amount}
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

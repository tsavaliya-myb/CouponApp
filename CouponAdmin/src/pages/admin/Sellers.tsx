import { useState } from "react";
import { mockSellers, mockRedemptions, cities, areasByCity, categories, type Seller } from "@/data/mock-data";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from "@/components/ui/sheet";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Card, CardContent } from "@/components/ui/card";
import { Search, CheckCircle, XCircle, Pause, Play, Pencil, Store, Clock, AlertTriangle } from "lucide-react";

const statusStyles: Record<string, string> = {
  active: "bg-[hsl(145,50%,95%)] text-[hsl(170,60%,35%)] border-0",
  pending: "bg-[hsl(35,80%,95%)] text-[hsl(35,70%,35%)] border-0",
  suspended: "bg-[hsl(340,50%,96%)] text-[hsl(340,65%,42%)] border-0",
};

export default function SellersPage() {
  const [search, setSearch] = useState("");
  const [cityFilter, setCityFilter] = useState("all");
  const [areaFilter, setAreaFilter] = useState("all");
  const [catFilter, setCatFilter] = useState("all");
  const [statusFilter, setStatusFilter] = useState("all");
  const [selectedSeller, setSelectedSeller] = useState<Seller | null>(null);
  const [editOpen, setEditOpen] = useState(false);
  const [editSeller, setEditSeller] = useState<Seller | null>(null);
  const [editCommission, setEditCommission] = useState("");

  const areas = cityFilter !== "all" ? areasByCity[cityFilter] || [] : [];

  const filtered = mockSellers.filter((s) => {
    if (search && !s.businessName.toLowerCase().includes(search.toLowerCase())) return false;
    if (cityFilter !== "all" && s.city !== cityFilter) return false;
    if (areaFilter !== "all" && s.area !== areaFilter) return false;
    if (catFilter !== "all" && s.category !== catFilter) return false;
    if (statusFilter !== "all" && s.status !== statusFilter) return false;
    return true;
  });

  const sellerRedemptions = selectedSeller ? mockRedemptions.filter((r) => r.sellerId === selectedSeller.id) : [];

  const activeCount = mockSellers.filter((s) => s.status === "active").length;
  const pendingCount = mockSellers.filter((s) => s.status === "pending").length;
  const suspendedCount = mockSellers.filter((s) => s.status === "suspended").length;

  return (
    <div className="space-y-6">
      <div className="animate-in-view">
        <h1 className="text-2xl md:text-3xl font-bold tracking-tight">Seller Management</h1>
        <p className="text-muted-foreground mt-1">{mockSellers.length} registered sellers</p>
      </div>

      {/* Summary cards */}
      <div className="grid grid-cols-3 gap-4 animate-in-view" style={{ animationDelay: "60ms" }}>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2 rounded-lg bg-[hsl(145,50%,95%)]">
              <Store className="h-4 w-4 text-[hsl(170,60%,42%)]" />
            </div>
            <div>
              <p className="text-2xl font-bold tabular-nums">{activeCount}</p>
              <p className="text-xs text-muted-foreground">Active</p>
            </div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2 rounded-lg bg-[hsl(35,80%,95%)]">
              <Clock className="h-4 w-4 text-[hsl(35,92%,42%)]" />
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
              <AlertTriangle className="h-4 w-4 text-[hsl(340,65%,52%)]" />
            </div>
            <div>
              <p className="text-2xl font-bold tabular-nums">{suspendedCount}</p>
              <p className="text-xs text-muted-foreground">Suspended</p>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <div className="flex flex-wrap gap-3 animate-in-view" style={{ animationDelay: "120ms" }}>
        <div className="relative w-64">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input placeholder="Search business name…" className="pl-9 rounded-lg h-10" value={search} onChange={(e) => setSearch(e.target.value)} />
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
        <Select value={catFilter} onValueChange={setCatFilter}>
          <SelectTrigger className="w-36 rounded-lg h-10"><SelectValue placeholder="Category" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Categories</SelectItem>
            {categories.map((c) => <SelectItem key={c} value={c}>{c}</SelectItem>)}
          </SelectContent>
        </Select>
        <Select value={statusFilter} onValueChange={setStatusFilter}>
          <SelectTrigger className="w-36 rounded-lg h-10"><SelectValue placeholder="Status" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Status</SelectItem>
            <SelectItem value="pending">Pending</SelectItem>
            <SelectItem value="active">Active</SelectItem>
            <SelectItem value="suspended">Suspended</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {/* Table */}
      <Card className="border-0 shadow-sm overflow-hidden animate-in-view" style={{ animationDelay: "180ms" }}>
        <Table>
          <TableHeader>
            <TableRow className="bg-muted/50 hover:bg-muted/50">
              <TableHead className="font-semibold">Business</TableHead>
              <TableHead className="hidden md:table-cell font-semibold">Category</TableHead>
              <TableHead className="hidden lg:table-cell font-semibold">City</TableHead>
              <TableHead className="hidden lg:table-cell font-semibold">Area</TableHead>
              <TableHead className="text-right hidden md:table-cell font-semibold">Commission</TableHead>
              <TableHead className="font-semibold">Status</TableHead>
              <TableHead className="text-right font-semibold">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {filtered.map((s) => (
              <TableRow key={s.id} className="cursor-pointer hover:bg-accent/50 transition-colors" onClick={() => setSelectedSeller(s)}>
                <TableCell className="font-medium">{s.businessName}</TableCell>
                <TableCell className="hidden md:table-cell text-muted-foreground">{s.category}</TableCell>
                <TableCell className="hidden lg:table-cell text-muted-foreground">{s.city}</TableCell>
                <TableCell className="hidden lg:table-cell text-muted-foreground">{s.area}</TableCell>
                <TableCell className="text-right hidden md:table-cell tabular-nums font-medium">{s.commission}%</TableCell>
                <TableCell>
                  <Badge variant="secondary" className={`${statusStyles[s.status]} font-medium`}>{s.status}</Badge>
                </TableCell>
                <TableCell className="text-right">
                  <div className="flex justify-end gap-1" onClick={(e) => e.stopPropagation()}>
                    {s.status === "pending" && (
                      <>
                        <Button size="icon" variant="ghost" className="h-8 w-8 rounded-lg text-[hsl(170,60%,42%)] hover:bg-[hsl(145,50%,95%)]" title="Approve">
                          <CheckCircle className="h-4 w-4" />
                        </Button>
                        <Button size="icon" variant="ghost" className="h-8 w-8 rounded-lg text-[hsl(0,72%,51%)] hover:bg-[hsl(340,50%,96%)]" title="Reject">
                          <XCircle className="h-4 w-4" />
                        </Button>
                      </>
                    )}
                    {s.status === "active" && (
                      <Button size="icon" variant="ghost" className="h-8 w-8 rounded-lg hover:bg-accent" title="Suspend">
                        <Pause className="h-4 w-4" />
                      </Button>
                    )}
                    {s.status === "suspended" && (
                      <Button size="icon" variant="ghost" className="h-8 w-8 rounded-lg hover:bg-accent" title="Reactivate">
                        <Play className="h-4 w-4" />
                      </Button>
                    )}
                    <Button size="icon" variant="ghost" className="h-8 w-8 rounded-lg hover:bg-accent" title="Edit commission" onClick={() => { setEditSeller(s); setEditCommission(String(s.commission)); setEditOpen(true); }}>
                      <Pencil className="h-4 w-4" />
                    </Button>
                  </div>
                </TableCell>
              </TableRow>
            ))}
            {filtered.length === 0 && (
              <TableRow>
                <TableCell colSpan={7} className="text-center py-12 text-muted-foreground">No sellers found</TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </Card>

      {/* Seller Detail Sheet */}
      <Sheet open={!!selectedSeller} onOpenChange={(open) => !open && setSelectedSeller(null)}>
        <SheetContent className="sm:max-w-lg overflow-y-auto">
          {selectedSeller && (
            <>
              <SheetHeader>
                <SheetTitle className="text-xl">{selectedSeller.businessName}</SheetTitle>
                <SheetDescription>{selectedSeller.category} · {selectedSeller.city}, {selectedSeller.area}</SheetDescription>
              </SheetHeader>
              <div className="mt-5 space-y-3 text-sm">
                <div className="grid grid-cols-2 gap-3">
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Status</p>
                    <p className="font-semibold capitalize mt-0.5">{selectedSeller.status}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Commission</p>
                    <p className="font-semibold tabular-nums mt-0.5">{selectedSeller.commission}%</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Total Redemptions</p>
                    <p className="font-semibold tabular-nums mt-0.5">{selectedSeller.totalRedemptions}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Joined</p>
                    <p className="font-semibold mt-0.5">{selectedSeller.joinDate}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5 col-span-2">
                    <p className="text-muted-foreground text-xs font-medium">Contact</p>
                    <p className="font-semibold mt-0.5">{selectedSeller.phone} · {selectedSeller.email}</p>
                  </div>
                </div>

                <div className="pt-4">
                  <h3 className="font-semibold mb-3">Recent Redemptions</h3>
                  {sellerRedemptions.length === 0 && <p className="text-muted-foreground text-sm py-8 text-center">No redemptions yet</p>}
                  {sellerRedemptions.map((r) => (
                    <div key={r.id} className="rounded-xl bg-muted/40 p-3.5 text-sm mb-2">
                      <div className="flex justify-between">
                        <span className="font-semibold">{r.couponName}</span>
                        <span className="text-muted-foreground text-xs">{r.date}</span>
                      </div>
                      <p className="text-muted-foreground mt-1">
                        Bill ₹{r.billAmount} → ₹{r.finalAmount}
                        {r.coinsUsed > 0 && ` · ${r.coinsUsed} coins used`}
                      </p>
                    </div>
                  ))}
                </div>
              </div>
            </>
          )}
        </SheetContent>
      </Sheet>

      {/* Edit Commission Dialog */}
      <Dialog open={editOpen} onOpenChange={setEditOpen}>
        <DialogContent className="rounded-xl">
          <DialogHeader>
            <DialogTitle>Edit Commission — {editSeller?.businessName}</DialogTitle>
          </DialogHeader>
          <div className="py-2">
            <Label className="text-sm font-medium">Commission %</Label>
            <Input type="number" value={editCommission} onChange={(e) => setEditCommission(e.target.value)} className="mt-1.5 rounded-lg" />
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setEditOpen(false)} className="rounded-lg">Cancel</Button>
            <Button onClick={() => setEditOpen(false)} className="rounded-lg">Save</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}

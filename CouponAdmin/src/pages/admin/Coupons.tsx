import { useState } from "react";
import { mockCoupons, mockSellers, type Coupon } from "@/data/mock-data";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from "@/components/ui/sheet";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { Card, CardContent } from "@/components/ui/card";
import { Search, Plus, Pencil, Ticket, TicketCheck, IndianRupee } from "lucide-react";

export default function CouponsPage() {
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");
  const [selectedCoupon, setSelectedCoupon] = useState<Coupon | null>(null);
  const [createOpen, setCreateOpen] = useState(false);

  const [formSeller, setFormSeller] = useState("");
  const [formName, setFormName] = useState("");
  const [formDiscount, setFormDiscount] = useState("");
  const [formCommission, setFormCommission] = useState("5");
  const [formMinSpend, setFormMinSpend] = useState("");
  const [formMaxUses, setFormMaxUses] = useState("3");
  const [formType, setFormType] = useState<string>("percentage");
  const [formActive, setFormActive] = useState(true);

  const filtered = mockCoupons.filter((c) => {
    if (search && !c.name.toLowerCase().includes(search.toLowerCase()) && !c.sellerName.toLowerCase().includes(search.toLowerCase())) return false;
    if (statusFilter !== "all" && c.status !== statusFilter) return false;
    return true;
  });

  const activeSellers = mockSellers.filter((s) => s.status === "active");

  const resetForm = () => {
    setFormSeller(""); setFormName(""); setFormDiscount(""); setFormCommission("5");
    setFormMinSpend(""); setFormMaxUses("3"); setFormType("percentage"); setFormActive(true);
  };

  const activeCount = mockCoupons.filter((c) => c.status === "active").length;
  const totalRedemptions = mockCoupons.reduce((sum, c) => sum + c.totalRedemptions, 0);
  const totalCommission = mockCoupons.reduce((sum, c) => sum + c.commissionGenerated, 0);

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between animate-in-view">
        <div>
          <h1 className="text-2xl md:text-3xl font-bold tracking-tight">Coupon Management</h1>
          <p className="text-muted-foreground mt-1">{mockCoupons.length} coupons</p>
        </div>
        <Button onClick={() => { resetForm(); setCreateOpen(true); }} className="rounded-lg shadow-sm shadow-primary/20 active:scale-[0.97] transition-transform">
          <Plus className="h-4 w-4 mr-1.5" /> Create Coupon
        </Button>
      </div>

      {/* Summary cards */}
      <div className="grid grid-cols-3 gap-4 animate-in-view" style={{ animationDelay: "60ms" }}>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2 rounded-lg bg-[hsl(250,55%,96%)]">
              <Ticket className="h-4 w-4 text-[hsl(250,60%,52%)]" />
            </div>
            <div>
              <p className="text-2xl font-bold tabular-nums">{activeCount}</p>
              <p className="text-xs text-muted-foreground">Active Coupons</p>
            </div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2 rounded-lg bg-[hsl(170,50%,94%)]">
              <TicketCheck className="h-4 w-4 text-[hsl(170,60%,42%)]" />
            </div>
            <div>
              <p className="text-2xl font-bold tabular-nums">{totalRedemptions}</p>
              <p className="text-xs text-muted-foreground">Total Redemptions</p>
            </div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2 rounded-lg bg-[hsl(35,80%,95%)]">
              <IndianRupee className="h-4 w-4 text-[hsl(35,92%,42%)]" />
            </div>
            <div>
              <p className="text-2xl font-bold tabular-nums">₹{totalCommission.toLocaleString("en-IN")}</p>
              <p className="text-xs text-muted-foreground">Commission Earned</p>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <div className="flex flex-wrap gap-3 animate-in-view" style={{ animationDelay: "120ms" }}>
        <div className="relative w-64">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input placeholder="Search coupon or seller…" className="pl-9 rounded-lg h-10" value={search} onChange={(e) => setSearch(e.target.value)} />
        </div>
        <Select value={statusFilter} onValueChange={setStatusFilter}>
          <SelectTrigger className="w-36 rounded-lg h-10"><SelectValue placeholder="Status" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Status</SelectItem>
            <SelectItem value="active">Active</SelectItem>
            <SelectItem value="inactive">Inactive</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {/* Table */}
      <Card className="border-0 shadow-sm overflow-hidden animate-in-view" style={{ animationDelay: "180ms" }}>
        <Table>
          <TableHeader>
            <TableRow className="bg-muted/50 hover:bg-muted/50">
              <TableHead className="font-semibold">Coupon</TableHead>
              <TableHead className="hidden md:table-cell font-semibold">Seller</TableHead>
              <TableHead className="text-right font-semibold">Discount</TableHead>
              <TableHead className="text-right hidden md:table-cell font-semibold">Commission</TableHead>
              <TableHead className="text-right hidden lg:table-cell font-semibold">Min Spend</TableHead>
              <TableHead className="text-right hidden lg:table-cell font-semibold">Max Uses</TableHead>
              <TableHead className="font-semibold">Status</TableHead>
              <TableHead className="text-right hidden md:table-cell font-semibold">Redemptions</TableHead>
              <TableHead className="text-right font-semibold">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {filtered.map((c) => (
              <TableRow key={c.id} className="cursor-pointer hover:bg-accent/50 transition-colors" onClick={() => setSelectedCoupon(c)}>
                <TableCell>
                  <div>
                    <span className="font-medium">{c.name}</span>
                    <span className="block md:hidden text-xs text-muted-foreground">{c.sellerName}</span>
                  </div>
                </TableCell>
                <TableCell className="hidden md:table-cell text-muted-foreground">{c.sellerName}</TableCell>
                <TableCell className="text-right tabular-nums font-medium">
                  {c.type === "bogo" ? (
                    <Badge variant="secondary" className="bg-[hsl(250,55%,96%)] text-[hsl(250,60%,52%)] border-0 font-semibold">BOGO</Badge>
                  ) : `${c.discountPercent}%`}
                </TableCell>
                <TableCell className="text-right tabular-nums hidden md:table-cell text-muted-foreground">{c.commissionPercent}%</TableCell>
                <TableCell className="text-right tabular-nums hidden lg:table-cell text-muted-foreground">{c.minSpend > 0 ? `₹${c.minSpend}` : "—"}</TableCell>
                <TableCell className="text-right tabular-nums hidden lg:table-cell text-muted-foreground">{c.maxUses}</TableCell>
                <TableCell>
                  <Badge variant="secondary" className={
                    c.status === "active"
                      ? "bg-[hsl(145,50%,95%)] text-[hsl(170,60%,35%)] border-0 font-medium"
                      : "bg-muted text-muted-foreground border-0 font-medium"
                  }>
                    {c.status}
                  </Badge>
                </TableCell>
                <TableCell className="text-right tabular-nums hidden md:table-cell font-medium">{c.totalRedemptions}</TableCell>
                <TableCell className="text-right" onClick={(e) => e.stopPropagation()}>
                  <Button size="icon" variant="ghost" className="h-8 w-8 rounded-lg hover:bg-accent" title="Edit" onClick={() => setSelectedCoupon(c)}>
                    <Pencil className="h-4 w-4" />
                  </Button>
                </TableCell>
              </TableRow>
            ))}
            {filtered.length === 0 && (
              <TableRow>
                <TableCell colSpan={9} className="text-center py-12 text-muted-foreground">No coupons found</TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </Card>

      {/* Coupon Detail Sheet */}
      <Sheet open={!!selectedCoupon} onOpenChange={(open) => !open && setSelectedCoupon(null)}>
        <SheetContent className="sm:max-w-lg overflow-y-auto">
          {selectedCoupon && (
            <>
              <SheetHeader>
                <SheetTitle className="text-xl">{selectedCoupon.name}</SheetTitle>
                <SheetDescription>{selectedCoupon.sellerName}</SheetDescription>
              </SheetHeader>
              <div className="mt-5 space-y-3 text-sm">
                <div className="grid grid-cols-2 gap-3">
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Type</p>
                    <p className="font-semibold capitalize mt-0.5">{selectedCoupon.type === "bogo" ? "Buy 1 Get 1" : selectedCoupon.type}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">User Discount</p>
                    <p className="font-semibold tabular-nums mt-0.5">{selectedCoupon.type === "bogo" ? "BOGO" : `${selectedCoupon.discountPercent}%`}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Admin Commission</p>
                    <p className="font-semibold tabular-nums mt-0.5">{selectedCoupon.commissionPercent}%</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Min Spend</p>
                    <p className="font-semibold tabular-nums mt-0.5">{selectedCoupon.minSpend > 0 ? `₹${selectedCoupon.minSpend}` : "None"}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Max Uses / User</p>
                    <p className="font-semibold tabular-nums mt-0.5">{selectedCoupon.maxUses}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Status</p>
                    <p className="font-semibold capitalize mt-0.5">{selectedCoupon.status}</p>
                  </div>
                </div>

                <div className="pt-4">
                  <h3 className="font-semibold mb-3">Performance</h3>
                  <div className="grid grid-cols-2 gap-3">
                    <div className="rounded-xl bg-[hsl(250,55%,96%)] p-4">
                      <p className="text-muted-foreground text-xs font-medium">Total Redemptions</p>
                      <p className="text-2xl font-bold tabular-nums mt-1">{selectedCoupon.totalRedemptions}</p>
                    </div>
                    <div className="rounded-xl bg-[hsl(170,50%,94%)] p-4">
                      <p className="text-muted-foreground text-xs font-medium">Commission Generated</p>
                      <p className="text-2xl font-bold tabular-nums mt-1">₹{selectedCoupon.commissionGenerated.toLocaleString("en-IN")}</p>
                    </div>
                  </div>
                </div>
              </div>
            </>
          )}
        </SheetContent>
      </Sheet>

      {/* Create Coupon Dialog */}
      <Dialog open={createOpen} onOpenChange={setCreateOpen}>
        <DialogContent className="max-w-md rounded-xl">
          <DialogHeader>
            <DialogTitle>Create Coupon</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 py-2 max-h-[60vh] overflow-y-auto">
            <div>
              <Label className="text-sm font-medium">Seller</Label>
              <Select value={formSeller} onValueChange={setFormSeller}>
                <SelectTrigger className="mt-1.5 rounded-lg"><SelectValue placeholder="Select seller" /></SelectTrigger>
                <SelectContent>
                  {activeSellers.map((s) => <SelectItem key={s.id} value={s.id}>{s.businessName}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div>
              <Label className="text-sm font-medium">Coupon Name</Label>
              <Input className="mt-1.5 rounded-lg" placeholder="e.g. 20% Off Lunch" value={formName} onChange={(e) => setFormName(e.target.value)} />
            </div>
            <div>
              <Label className="text-sm font-medium">Coupon Type</Label>
              <Select value={formType} onValueChange={setFormType}>
                <SelectTrigger className="mt-1.5 rounded-lg"><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="percentage">Percentage Off</SelectItem>
                  <SelectItem value="bogo">Buy 1 Get 1</SelectItem>
                  <SelectItem value="flat">Flat Discount</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="grid grid-cols-2 gap-3">
              <div>
                <Label className="text-sm font-medium">Discount %</Label>
                <Input type="number" className="mt-1.5 rounded-lg" value={formDiscount} onChange={(e) => setFormDiscount(e.target.value)} />
              </div>
              <div>
                <Label className="text-sm font-medium">Commission %</Label>
                <Input type="number" className="mt-1.5 rounded-lg" value={formCommission} onChange={(e) => setFormCommission(e.target.value)} />
              </div>
            </div>
            <div className="grid grid-cols-2 gap-3">
              <div>
                <Label className="text-sm font-medium">Min Spend (₹)</Label>
                <Input type="number" className="mt-1.5 rounded-lg" placeholder="0" value={formMinSpend} onChange={(e) => setFormMinSpend(e.target.value)} />
              </div>
              <div>
                <Label className="text-sm font-medium">Max Uses / User</Label>
                <Input type="number" className="mt-1.5 rounded-lg" value={formMaxUses} onChange={(e) => setFormMaxUses(e.target.value)} />
              </div>
            </div>
            <div className="flex items-center justify-between rounded-lg bg-muted/50 p-3">
              <Label className="text-sm font-medium">Active</Label>
              <Switch checked={formActive} onCheckedChange={setFormActive} />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setCreateOpen(false)} className="rounded-lg">Cancel</Button>
            <Button onClick={() => setCreateOpen(false)} className="rounded-lg">Create</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}

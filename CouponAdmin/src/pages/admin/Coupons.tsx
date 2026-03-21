import { useState } from "react";
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
import { Plus, Pencil, Ticket, TicketCheck, IndianRupee, Loader2, AlertTriangle, Building2, Store, PowerOff, Power } from "lucide-react";

import { useCoupons, useCreateCoupon, useUpdateCoupon, useToggleCouponStatus } from "@/hooks/api/useCoupons";
import { useCities } from "@/hooks/api/useLocation";
import { useSellers } from "@/hooks/api/useSellers";
import { Coupon } from "@/types/api/coupons";
import { format } from "date-fns";
import { toast } from "sonner";

export default function CouponsPage() {
  const [cityFilter, setCityFilter] = useState("all");
  const [sellerFilter, setSellerFilter] = useState("all");
  const [typeFilter, setTypeFilter] = useState("all");

  const [selectedCoupon, setSelectedCoupon] = useState<Coupon | null>(null);
  const [createOpen, setCreateOpen] = useState(false);
  const [editOpen, setEditOpen] = useState(false);
  const [editCouponId, setEditCouponId] = useState<string | null>(null);

  // Loaders
  const { data: citiesData, isLoading: isCitiesLoading } = useCities();
  const apiCities = citiesData?.data || [];

  const { data: sellersData, isLoading: isSellersLoading } = useSellers(
    cityFilter !== "all" ? { cityId: cityFilter, limit: 100 } : { limit: 100 }
  );
  const apiSellers = sellersData?.data || [];

  const { data: couponsData, isLoading, isError } = useCoupons({
    page: 1,
    limit: 50,
    ...(cityFilter !== "all" && { cityId: cityFilter }),
    ...(sellerFilter !== "all" && { sellerId: sellerFilter }),
    ...(typeFilter !== "all" && { type: typeFilter }),
  });
  const coupons = couponsData?.data || [];
  const createMutation = useCreateCoupon();
  const updateMutation = useUpdateCoupon();
  const toggleMutation = useToggleCouponStatus();

  // Dialog State
  const [formSeller, setFormSeller] = useState("");
  const [formName, setFormName] = useState("");
  const [formDiscount, setFormDiscount] = useState("");
  const [formCommission, setFormCommission] = useState("5");
  const [formMinSpend, setFormMinSpend] = useState("");
  const [formMaxUses, setFormMaxUses] = useState("3");
  const [formType, setFormType] = useState<string>("STANDARD");
  const [formActive, setFormActive] = useState(true);

  const resetForm = () => {
    setFormSeller(""); setFormName(""); setFormDiscount(""); setFormCommission("5");
    setFormMinSpend(""); setFormMaxUses("3"); setFormType("STANDARD"); setFormActive(true);
  };

  const openEditModal = (c: Coupon) => {
    setEditCouponId(c.id);
    setFormDiscount(String(c.discountPct));
    setFormCommission(String(c.adminCommissionPct));
    setFormMinSpend(c.minSpend ? String(c.minSpend) : "");
    setFormMaxUses(String(c.maxUsesPerBook));
    setFormType(c.type);
    setEditOpen(true);
  };

  const activeCount = coupons.filter((c) => c.status === "ACTIVE").length;
  const totalRedemptions = coupons.reduce((sum, c) => sum + (c.totalRedemptions || 0), 0);

  const handleToggleStatus = (id: string, currentStatus: string) => {
    const isActivating = currentStatus !== "ACTIVE";
    const actionText = isActivating ? "activate" : "deactivate";
    if (confirm(`Are you sure you want to ${actionText} this coupon?`)) {
      const toastId = toast.loading(`${isActivating ? 'Activating' : 'Deactivating'} coupon...`);
      toggleMutation.mutate(id, {
        onSuccess: () => toast.success(`Coupon ${actionText}d`, { id: toastId }),
        onError: () => toast.error(`Failed to ${actionText}`, { id: toastId })
      });
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between animate-in-view">
        <div>
          <h1 className="text-2xl md:text-3xl font-bold tracking-tight">Coupon Management</h1>
          <p className="text-muted-foreground mt-1">{coupons.length} current coupons matching filter</p>
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
        {/* <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2 rounded-lg bg-[hsl(35,80%,95%)]">
              <IndianRupee className="h-4 w-4 text-[hsl(35,92%,42%)]" />
            </div>
            <div>
              <p className="text-2xl font-bold tabular-nums">₹0</p>
              <p className="text-xs text-muted-foreground">Commission Earned (WIP)</p>
            </div>
          </CardContent>
        </Card> */}
      </div>

      {/* Filters */}
      <div className="flex flex-wrap gap-3 animate-in-view" style={{ animationDelay: "120ms" }}>
        <Select value={cityFilter} onValueChange={setCityFilter}>
          <SelectTrigger className="w-40 rounded-lg h-10">
            <Building2 className="h-4 w-4 mr-2 text-muted-foreground" />
            <SelectValue placeholder={isCitiesLoading ? "Loading..." : "All Cities"} />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Cities</SelectItem>
            {apiCities.map((c) => <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>)}
          </SelectContent>
        </Select>

        <Select value={sellerFilter} onValueChange={setSellerFilter} disabled={isSellersLoading}>
          <SelectTrigger className="w-52 rounded-lg h-10">
            <Store className="h-4 w-4 mr-2 text-muted-foreground" />
            <SelectValue placeholder={isSellersLoading ? "Loading..." : "All Sellers"} />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Sellers</SelectItem>
            {apiSellers.map((s) => <SelectItem key={s.id} value={s.id}>{s.businessName}</SelectItem>)}
          </SelectContent>
        </Select>

        <Select value={typeFilter} onValueChange={setTypeFilter}>
          <SelectTrigger className="w-36 rounded-lg h-10"><SelectValue placeholder="Type" /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Types</SelectItem>
            <SelectItem value="STANDARD">Standard</SelectItem>
            <SelectItem value="BOGO">BOGO</SelectItem>
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
            {isLoading ? (
              <TableRow>
                <TableCell colSpan={9} className="h-32 text-center">
                  <div className="flex flex-col items-center justify-center text-muted-foreground space-y-2">
                    <Loader2 className="h-6 w-6 animate-spin" />
                    <span>Loading coupons...</span>
                  </div>
                </TableCell>
              </TableRow>
            ) : isError ? (
              <TableRow>
                <TableCell colSpan={9} className="h-32 text-center">
                  <div className="flex flex-col items-center justify-center text-destructive space-y-2">
                    <AlertTriangle className="h-6 w-6" />
                    <span>Failed to load coupons</span>
                  </div>
                </TableCell>
              </TableRow>
            ) : coupons.length === 0 ? (
              <TableRow>
                <TableCell colSpan={9} className="text-center py-12 text-muted-foreground">No coupons found</TableCell>
              </TableRow>
            ) : coupons.map((c) => (
              <TableRow key={c.id} className="cursor-pointer hover:bg-accent/50 transition-colors" onClick={() => setSelectedCoupon(c)}>
                <TableCell>
                  <div>
                    <span className="font-medium text-[hsl(250,60%,52%)]">{c.id.split('-')[0].toUpperCase()} ({c.type})</span>
                    <span className="block md:hidden text-xs text-muted-foreground">{c.seller?.businessName}</span>
                  </div>
                </TableCell>
                <TableCell className="hidden md:table-cell text-muted-foreground">{c.seller?.businessName}</TableCell>
                <TableCell className="text-right tabular-nums font-medium">
                  {c.type === "BOGO" ? (
                    <Badge variant="secondary" className="bg-[hsl(250,55%,96%)] text-[hsl(250,60%,52%)] border-0 font-semibold">BOGO</Badge>
                  ) : `${c.discountPct}%`}
                </TableCell>
                <TableCell className="text-right tabular-nums hidden md:table-cell text-muted-foreground">{c.adminCommissionPct}%</TableCell>
                <TableCell className="text-right tabular-nums hidden lg:table-cell text-muted-foreground">{c.minSpend ? `₹${c.minSpend}` : "—"}</TableCell>
                <TableCell className="text-right tabular-nums hidden lg:table-cell text-muted-foreground">{c.maxUsesPerBook}</TableCell>
                <TableCell>
                  <Badge variant="secondary" className={
                    c.status === "ACTIVE"
                      ? "bg-[hsl(145,50%,95%)] text-[hsl(170,60%,35%)] border-0 font-medium"
                      : "bg-muted text-muted-foreground border-0 font-medium"
                  }>
                    {c.status}
                  </Badge>
                </TableCell>
                <TableCell className="text-right tabular-nums hidden md:table-cell font-medium">{c.totalRedemptions || 0}</TableCell>
                <TableCell className="text-right" onClick={(e) => e.stopPropagation()}>
                  <div className="flex items-center justify-end gap-2">
                    {c.status === "ACTIVE" ? (
                      <Button size="icon" variant="ghost" className="h-8 w-8 rounded-lg hover:bg-destructive/10 hover:text-destructive" title="Deactivate" onClick={() => handleToggleStatus(c.id, c.status)}>
                        <PowerOff className="h-4 w-4" />
                      </Button>
                    ) : (
                      <Button size="icon" variant="ghost" className="h-8 w-8 rounded-lg hover:bg-emerald-500/10 hover:text-emerald-600 text-emerald-500" title="Reactivate" onClick={() => handleToggleStatus(c.id, c.status)}>
                        <Power className="h-4 w-4" />
                      </Button>
                    )}
                    <Button size="icon" variant="ghost" className="h-8 w-8 rounded-lg hover:bg-accent" title="Edit" onClick={() => openEditModal(c)}>
                      <Pencil className="h-4 w-4" />
                    </Button>
                  </div>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </Card>

      {/* Coupon Detail Sheet */}
      <Sheet open={!!selectedCoupon} onOpenChange={(open) => !open && setSelectedCoupon(null)}>
        <SheetContent className="sm:max-w-lg overflow-y-auto">
          {selectedCoupon && (
            <>
              <SheetHeader>
                <SheetTitle className="text-xl">{selectedCoupon.id.split('-')[0].toUpperCase()} Coupon Group</SheetTitle>
                <SheetDescription>{selectedCoupon.seller?.businessName} • Created {format(new Date(selectedCoupon.createdAt), "MMM d, yyyy")}</SheetDescription>
              </SheetHeader>
              <div className="mt-5 space-y-3 text-sm">
                <div className="grid grid-cols-2 gap-3">
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Type</p>
                    <p className="font-semibold capitalize mt-0.5">{selectedCoupon.type === "BOGO" ? "Buy 1 Get 1" : selectedCoupon.type}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">User Discount</p>
                    <p className="font-semibold tabular-nums mt-0.5">{selectedCoupon.type === "BOGO" ? "BOGO" : `${selectedCoupon.discountPct}%`}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Admin Commission</p>
                    <p className="font-semibold tabular-nums mt-0.5">{selectedCoupon.adminCommissionPct}%</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Min Spend</p>
                    <p className="font-semibold tabular-nums mt-0.5">{selectedCoupon.minSpend ? `₹${selectedCoupon.minSpend}` : "None"}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Max Uses / User</p>
                    <p className="font-semibold tabular-nums mt-0.5">{selectedCoupon.maxUsesPerBook}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Status</p>
                    <p className="font-semibold capitalize mt-0.5">{selectedCoupon.status}</p>
                  </div>
                </div>

                <div className="pt-4">
                  <h3 className="font-semibold mb-3">Performance (Commission Pending API)</h3>
                  <div className="grid grid-cols-2 gap-3">
                    <div className="rounded-xl bg-[hsl(250,55%,96%)] p-4">
                      <p className="text-muted-foreground text-xs font-medium">Total Redemptions</p>
                      <p className="text-2xl font-bold tabular-nums mt-1">{selectedCoupon.totalRedemptions || 0}</p>
                    </div>
                    <div className="rounded-xl bg-[hsl(170,50%,94%)] p-4">
                      <p className="text-muted-foreground text-xs font-medium">Commission Generated</p>
                      <p className="text-2xl font-bold tabular-nums mt-1">₹0</p>
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
              <Select value={formSeller} onValueChange={setFormSeller} disabled={isSellersLoading}>
                <SelectTrigger className="mt-1.5 rounded-lg"><SelectValue placeholder={isSellersLoading ? "Loading..." : "Select seller"} /></SelectTrigger>
                <SelectContent>
                  {apiSellers.map((s) => <SelectItem key={s.id} value={s.id}>{s.businessName}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div>
              <Label className="text-sm font-medium">Coupon Name (Unused)</Label>
              <Input className="mt-1.5 rounded-lg" placeholder="e.g. 20% Off Lunch [API doesn't have name]" value={formName} onChange={(e) => setFormName(e.target.value)} disabled />
            </div>
            <div>
              <Label className="text-sm font-medium">Coupon Type</Label>
              <Select value={formType} onValueChange={setFormType}>
                <SelectTrigger className="mt-1.5 rounded-lg"><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="STANDARD">Percentage Off / Standard</SelectItem>
                  <SelectItem value="BOGO">Buy 1 Get 1 (BOGO)</SelectItem>
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
            <Button
              className="rounded-lg"
              disabled={createMutation.isPending || !formSeller || !formDiscount || !formCommission || !formMaxUses}
              onClick={() => {
                createMutation.mutate({
                  sellerId: formSeller,
                  discountPct: Number(formDiscount),
                  adminCommissionPct: Number(formCommission),
                  minSpend: Number(formMinSpend) || 0,
                  maxUsesPerBook: Number(formMaxUses),
                  type: formType,
                  isBaseCoupon: true
                }, {
                  onSuccess: () => {
                    toast.success("Coupon created successfully");
                    setCreateOpen(false);
                    resetForm();
                  },
                  onError: (err: any) => toast.error(err.response?.data?.message || "Failed to create coupon")
                })
              }}
            >
              {createMutation.isPending ? <Loader2 className="h-4 w-4 animate-spin" /> : "Create"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Edit Coupon Dialog */}
      <Dialog open={editOpen} onOpenChange={setEditOpen}>
        <DialogContent className="max-w-md rounded-xl">
          <DialogHeader>
            <DialogTitle>Edit Coupon</DialogTitle>
          </DialogHeader>
          <div className="space-y-4 py-2 max-h-[60vh] overflow-y-auto">
            <div>
              <Label className="text-sm font-medium">Coupon Type</Label>
              <Select value={formType} onValueChange={setFormType}>
                <SelectTrigger className="mt-1.5 rounded-lg"><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="STANDARD">Percentage Off / Standard</SelectItem>
                  <SelectItem value="BOGO">Buy 1 Get 1 (BOGO)</SelectItem>
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
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setEditOpen(false)} className="rounded-lg">Cancel</Button>
            <Button
              className="rounded-lg"
              disabled={updateMutation.isPending || !formDiscount || !formCommission || !formMaxUses}
              onClick={() => {
                if (editCouponId) {
                  updateMutation.mutate({
                    id: editCouponId,
                    data: {
                      discountPct: Number(formDiscount),
                      adminCommissionPct: Number(formCommission),
                      minSpend: Number(formMinSpend) || 0,
                      maxUsesPerBook: Number(formMaxUses),
                      type: formType,
                    }
                  }, {
                    onSuccess: () => {
                      toast.success("Coupon updated successfully");
                      setEditOpen(false);
                      resetForm();
                    },
                    onError: (err: any) => toast.error(err.response?.data?.message || "Failed to update coupon")
                  })
                }
              }}
            >
              {updateMutation.isPending ? <Loader2 className="h-4 w-4 animate-spin" /> : "Save Changes"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}

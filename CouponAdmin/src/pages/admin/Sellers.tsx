import { useState, useEffect } from "react";
import { categories } from "@/data/mock-data";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from "@/components/ui/sheet";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Card, CardContent } from "@/components/ui/card";
import { Search, CheckCircle, XCircle, Pause, Play, Pencil, Store, Clock, AlertTriangle, Loader2 } from "lucide-react";
import { useSellers, useApproveSeller, useSuspendSeller, useUpdateSeller, useRejectSeller } from "@/hooks/api/useSellers";
import { useCities, useAreas } from "@/hooks/api/useLocation";
import { Seller, UpdateSellerParams } from "@/types/api/sellers";
import { format } from "date-fns";
import { toast } from "sonner";

const statusStyles: Record<string, string> = {
  ACTIVE: "bg-[hsl(145,50%,95%)] text-[hsl(170,60%,35%)] border-0",
  PENDING: "bg-[hsl(35,80%,95%)] text-[hsl(35,70%,35%)] border-0",
  SUSPENDED: "bg-[hsl(340,50%,96%)] text-[hsl(340,65%,42%)] border-0",
  REJECTED: "bg-[hsl(0,72%,96%)] text-[hsl(0,72%,51%)] border-0",
  Rejected: "bg-[hsl(0,72%,96%)] text-[hsl(0,72%,51%)] border-0",
};

export default function SellersPage() {
  const [search, setSearch] = useState("");
  const [debouncedSearch, setDebouncedSearch] = useState("");
  const [cityFilter, setCityFilter] = useState("all");
  const [areaFilter, setAreaFilter] = useState("all");
  const [catFilter, setCatFilter] = useState("all");
  const [statusFilter, setStatusFilter] = useState("all");
  const [selectedSeller, setSelectedSeller] = useState<Seller | null>(null);
  const [editOpen, setEditOpen] = useState(false);
  const [editSeller, setEditSeller] = useState<Seller | null>(null);
  const [editForm, setEditForm] = useState<UpdateSellerParams>({});

  const approveMutation = useApproveSeller();
  const suspendMutation = useSuspendSeller();
  const rejectMutation = useRejectSeller();
  const updateMutation = useUpdateSeller();

  useEffect(() => {
    const handler = setTimeout(() => setDebouncedSearch(search), 400);
    return () => clearTimeout(handler);
  }, [search]);

  const { data: citiesData, isLoading: isCitiesLoading } = useCities();
  const apiCities = citiesData?.data || [];

  const { data: areasData, isLoading: isAreasLoading } = useAreas(cityFilter !== "all" ? cityFilter : null);
  const apiAreas = areasData?.data || [];

  const { data: editAreasData, isLoading: isEditAreasLoading } = useAreas(editForm.cityId || null);
  const editApiAreas = editAreasData?.data || [];

  const { data, isLoading, isError } = useSellers({
    page: 1,
    limit: 50,
    search: debouncedSearch || undefined,
    status: statusFilter !== "all" ? statusFilter : undefined,
    category: catFilter !== "all" ? catFilter : undefined,
    cityId: cityFilter !== "all" ? cityFilter : undefined,
    areaId: areaFilter !== "all" ? areaFilter : undefined,
  });

  const sellers = data?.data || [];
  const meta = data?.meta;

  const sellerRedemptions: any[] = [];

  const totalCount = meta?.total || 0;
  const activeCount = sellers.filter((s) => s.status === "ACTIVE").length;
  const pendingCount = sellers.filter((s) => s.status === "PENDING").length;
  const suspendedCount = sellers.filter((s) => s.status === "SUSPENDED" || s.status === "BLOCKED").length;

  return (
    <div className="space-y-6">
      <div className="animate-in-view">
        <h1 className="text-2xl md:text-3xl font-bold tracking-tight">Seller Management</h1>
        <p className="text-muted-foreground mt-1">{totalCount} registered sellers</p>
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
          <SelectTrigger className="w-36 rounded-lg h-10"><SelectValue placeholder={isCitiesLoading ? "Loading..." : "City"} /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Cities</SelectItem>
            {apiCities.map((c) => <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>)}
          </SelectContent>
        </Select>
        <Select value={areaFilter} onValueChange={setAreaFilter} disabled={cityFilter === "all" || isAreasLoading}>
          <SelectTrigger className="w-36 rounded-lg h-10"><SelectValue placeholder={isAreasLoading ? "Loading..." : "Area"} /></SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Areas</SelectItem>
            {apiAreas.map((a) => <SelectItem key={a.id} value={a.id}>{a.name}</SelectItem>)}
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
            <SelectItem value="PENDING">Pending</SelectItem>
            <SelectItem value="ACTIVE">Active</SelectItem>
            <SelectItem value="SUSPENDED">Suspended</SelectItem>
            <SelectItem value="REJECTED">Rejected</SelectItem>
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
            {isLoading && (
              <TableRow>
                <TableCell colSpan={7} className="text-center py-12">
                   <Loader2 className="mx-auto h-8 w-8 animate-spin text-muted-foreground" />
                </TableCell>
              </TableRow>
            )}
            
            {isError && (
              <TableRow>
                <TableCell colSpan={7} className="text-center py-12 text-destructive font-medium border border-destructive/20 bg-destructive/5 rounded-xl">
                   Failed to fetch seller directory. Please try again.
                </TableCell>
              </TableRow>
            )}

            {!isLoading && !isError && sellers.map((s) => (
              <TableRow key={s.id} className="cursor-pointer hover:bg-accent/50 transition-colors" onClick={() => setSelectedSeller(s)}>
                <TableCell className="font-medium">{s.businessName}</TableCell>
                <TableCell className="hidden md:table-cell text-muted-foreground capitalize">{s.category?.name}</TableCell>
                <TableCell className="hidden lg:table-cell text-muted-foreground capitalize">{s.city?.name || "-"}</TableCell>
                <TableCell className="hidden lg:table-cell text-muted-foreground capitalize">{s.area?.name || "-"}</TableCell>
                <TableCell className="text-right hidden md:table-cell tabular-nums font-medium">{s.commissionPct}%</TableCell>
                <TableCell>
                  <Badge variant="secondary" className={`${statusStyles[s.status] || "bg-muted text-foreground"} font-medium`}>{s.status}</Badge>
                </TableCell>
                <TableCell className="text-right">
                  <div className="flex justify-end gap-1" onClick={(e) => e.stopPropagation()}>
                    {s.status === "PENDING" && (
                      <>
                        <Button
                          size="icon"
                          variant="ghost" 
                          className="h-8 w-8 rounded-lg text-[hsl(170,60%,42%)] hover:bg-[hsl(145,50%,95%)]"
                          title="Approve"
                          disabled={approveMutation.isPending || suspendMutation.isPending}
                          onClick={() => {
                            approveMutation.mutate(s.id, {
                              onSuccess: () => toast.success(`Approved seller ${s.businessName}`),
                              onError: (err: any) => toast.error(err.response?.data?.message || "Failed to approve seller")
                            });
                          }}
                        >
                          {approveMutation.isPending && approveMutation.variables === s.id ? (
                            <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />
                          ) : (
                            <CheckCircle className="h-4 w-4" />
                          )}
                        </Button>
                        <Button 
                          size="icon" 
                          variant="ghost" 
                          className="h-8 w-8 rounded-lg text-[hsl(0,72%,51%)] hover:bg-[hsl(340,50%,96%)]" 
                          title="Reject"
                          disabled={rejectMutation.isPending || approveMutation.isPending}
                          onClick={() => {
                            rejectMutation.mutate(s.id, {
                              onSuccess: () => toast.success(`Rejected seller ${s.businessName}`),
                              onError: (err: any) => toast.error(err.response?.data?.message || "Failed to reject seller")
                            });
                          }}
                        >
                          {rejectMutation.isPending && rejectMutation.variables === s.id ? (
                            <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />
                          ) : (
                            <XCircle className="h-4 w-4" />
                          )}
                        </Button>
                      </>
                    )}
                    {s.status === "ACTIVE" && (
                      <Button
                        size="icon"
                        variant="ghost"
                        className="h-8 w-8 rounded-lg hover:bg-accent"
                        title="Suspend"
                        disabled={suspendMutation.isPending || approveMutation.isPending}
                        onClick={() => {
                          suspendMutation.mutate(s.id, {
                            onSuccess: () => toast.success(`Suspended seller ${s.businessName}`),
                            onError: (err: any) => toast.error(err.response?.data?.message || "Failed to suspend seller")
                          });
                        }}
                      >
                        {suspendMutation.isPending && suspendMutation.variables === s.id ? (
                          <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />
                        ) : (
                          <Pause className="h-4 w-4 text-muted-foreground hover:text-destructive transition-colors" />
                        )}
                      </Button>
                    )}
                    {(s.status === "SUSPENDED" || s.status === "REJECTED" || s.status === "Rejected") && (
                      <Button
                        size="icon"
                        variant="ghost"
                        className="h-8 w-8 rounded-lg hover:bg-accent"
                        title="Reactivate"
                        disabled={approveMutation.isPending || suspendMutation.isPending}
                        onClick={() => {
                          // Unsuspend mechanism -> Assuming approve moves them back to ACTIVE
                          approveMutation.mutate(s.id, {
                            onSuccess: () => toast.success(`Reactivated seller ${s.businessName}`),
                            onError: (err: any) => toast.error(err.response?.data?.message || "Failed to reactivate seller")
                          });
                        }}
                      >
                        {approveMutation.isPending && approveMutation.variables === s.id ? (
                          <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />
                        ) : (
                          <Play className="h-4 w-4 text-muted-foreground hover:text-primary transition-colors" />
                        )}
                      </Button>
                    )}
                    <Button size="icon" variant="ghost" className="h-8 w-8 rounded-lg hover:bg-accent" title="Edit Seller" onClick={() => { 
                      setEditSeller(s); 
                      setEditForm({
                        businessName: s.businessName,
                        category: s.category?.name,
                        cityId: s.cityId,
                        areaId: s.areaId,
                        upiId: s.upiId || undefined,
                        lat: s.latitude || undefined,
                        lng: s.longitude || undefined,
                        commissionPct: s.commissionPct,
                      });
                      setEditOpen(true); 
                    }}>
                      <Pencil className="h-4 w-4" />
                    </Button>
                  </div>
                </TableCell>
              </TableRow>
            ))}
            {!isLoading && !isError && sellers.length === 0 && (
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
                <SheetDescription>{selectedSeller.category?.name} · {selectedSeller.city?.name || "-"}, {selectedSeller.area?.name || "-"}</SheetDescription>
              </SheetHeader>
              <div className="mt-5 space-y-3 text-sm">
                <div className="grid grid-cols-2 gap-3">
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Status</p>
                    <p className="font-semibold capitalize mt-0.5">{selectedSeller.status}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Commission</p>
                    <p className="font-semibold tabular-nums mt-0.5">{selectedSeller.commissionPct}%</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Contact Phone</p>
                    <p className="font-semibold tabular-nums mt-0.5">{selectedSeller.phone || "-"}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5">
                    <p className="text-muted-foreground text-xs font-medium">Joined</p>
                    <p className="font-semibold mt-0.5">{format(new Date(selectedSeller.createdAt), "dd MMM, yyyy")}</p>
                  </div>
                  <div className="rounded-xl bg-muted/50 p-3.5 col-span-2">
                    <p className="text-muted-foreground text-xs font-medium">Email Address</p>
                    <p className="font-semibold mt-0.5">{selectedSeller.email || "No email provided"}</p>
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

      {/* Edit Seller Dialog */}
      <Dialog open={editOpen} onOpenChange={setEditOpen}>
        <DialogContent className="rounded-xl sm:max-w-md max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>Edit Seller — {editSeller?.businessName}</DialogTitle>
          </DialogHeader>
          <div className="py-2 space-y-4">
            <div>
              <Label className="text-sm font-medium">Business Name</Label>
              <Input value={editForm.businessName || ""} onChange={(e) => setEditForm(prev => ({ ...prev, businessName: e.target.value }))} className="mt-1.5 rounded-lg" />
            </div>
            <div>
              <Label className="text-sm font-medium">Category</Label>
              <Select value={editForm.category || ""} onValueChange={(val) => setEditForm(prev => ({ ...prev, category: val }))}>
                <SelectTrigger className="mt-1.5 rounded-lg"><SelectValue placeholder="Select Category" /></SelectTrigger>
                <SelectContent>
                  {categories.map((c) => <SelectItem key={c} value={c}>{c}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div className="grid grid-cols-2 gap-3">
              <div>
                <Label className="text-sm font-medium">City</Label>
                <Select value={editForm.cityId || ""} onValueChange={(val) => setEditForm(prev => ({ ...prev, cityId: val, areaId: undefined }))}>
                  <SelectTrigger className="mt-1.5 rounded-lg"><SelectValue placeholder={isCitiesLoading ? "Loading..." : "Select City"} /></SelectTrigger>
                  <SelectContent>
                    {apiCities.map((c) => <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>)}
                  </SelectContent>
                </Select>
              </div>
              <div>
                <Label className="text-sm font-medium">Area</Label>
                <Select value={editForm.areaId || ""} onValueChange={(val) => setEditForm(prev => ({ ...prev, areaId: val }))} disabled={!editForm.cityId || isEditAreasLoading}>
                  <SelectTrigger className="mt-1.5 rounded-lg"><SelectValue placeholder={isEditAreasLoading ? "Loading..." : "Select Area"} /></SelectTrigger>
                  <SelectContent>
                    {editApiAreas.map((a) => <SelectItem key={a.id} value={a.id}>{a.name}</SelectItem>)}
                  </SelectContent>
                </Select>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-3">
              <div>
                <Label className="text-sm font-medium">UPI ID</Label>
                <Input value={editForm.upiId || ""} onChange={(e) => setEditForm(prev => ({ ...prev, upiId: e.target.value }))} className="mt-1.5 rounded-lg" />
              </div>
              <div>
                <Label className="text-sm font-medium">Commission %</Label>
                <Input type="number" value={editForm.commissionPct ?? ""} onChange={(e) => setEditForm(prev => ({ ...prev, commissionPct: Number(e.target.value) }))} className="mt-1.5 rounded-lg" />
              </div>
            </div>
            <div className="grid grid-cols-2 gap-3">
              <div>
                <Label className="text-sm font-medium">Latitude</Label>
                <Input type="number" step="any" value={editForm.lat ?? ""} onChange={(e) => setEditForm(prev => ({ ...prev, lat: Number(e.target.value) }))} className="mt-1.5 rounded-lg" />
              </div>
              <div>
                <Label className="text-sm font-medium">Longitude</Label>
                <Input type="number" step="any" value={editForm.lng ?? ""} onChange={(e) => setEditForm(prev => ({ ...prev, lng: Number(e.target.value) }))} className="mt-1.5 rounded-lg" />
              </div>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setEditOpen(false)} className="rounded-lg">Cancel</Button>
            <Button 
              disabled={updateMutation.isPending}
              onClick={() => {
                if (editSeller && editForm) {
                  updateMutation.mutate({
                    id: editSeller.id,
                    data: editForm
                  }, {
                    onSuccess: () => {
                      toast.success(`Updated seller ${editForm.businessName || editSeller.businessName}`);
                      setEditOpen(false);
                    },
                    onError: (err: any) => toast.error(err.response?.data?.message || "Failed to update seller data")
                  });
                }
              }} 
              className="rounded-lg"
            >
              {updateMutation.isPending ? <Loader2 className="h-4 w-4 animate-spin" /> : "Save"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}

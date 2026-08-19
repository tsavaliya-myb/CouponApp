import { useState, useRef, useCallback } from "react";
import { format } from "date-fns";
import { toast } from "sonner";
import {
  Image,
  Plus,
  Pause,
  Play,
  Pencil,
  Trash2,
  Loader2,
  BarChart2,
  Eye,
  MousePointerClick,
  CalendarDays,
  MapPin,
  Upload,
  X,
  ImageIcon,
  Video,
} from "lucide-react";
import axios from "axios";

import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent } from "@/components/ui/card";
import {
  Table, TableBody, TableCell, TableHead, TableHeader, TableRow,
} from "@/components/ui/table";
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter,
} from "@/components/ui/dialog";
import {
  AlertDialog, AlertDialogAction, AlertDialogCancel, AlertDialogContent,
  AlertDialogDescription, AlertDialogFooter, AlertDialogHeader, AlertDialogTitle,
} from "@/components/ui/alert-dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import {
  useBannerAds,
  useCreateBannerAd,
  useUpdateBannerAd,
  usePauseBannerAd,
  useResumeBannerAd,
  useDeleteBannerAd,
  usePresignBannerMedia,
} from "@/hooks/api/useBannerAds";
import { useCities } from "@/hooks/api/useLocation";
import { useSellers } from "@/hooks/api/useSellers";
import { BannerAd, BannerAdStatus, CreateBannerAdPayload, UpdateBannerAdPayload } from "@/types/api/ads";

// ─── Status badge styles ──────────────────────────────────────────────────────

const statusStyle: Record<BannerAdStatus, string> = {
  ACTIVE: "bg-[hsl(145,50%,95%)] text-[hsl(170,60%,35%)] border-0",
  PAUSED: "bg-[hsl(35,80%,95%)]  text-[hsl(35,70%,35%)]  border-0",
  COMPLETED: "bg-muted text-muted-foreground border-0",
};

// ─── Empty form state ─────────────────────────────────────────────────────────

const emptyForm = (): CreateBannerAdPayload => ({
  title: "",
  sellerId: undefined,
  imageUrl: "",
  videoUrl: "",
  actionUrl: "",
  cityIds: [],
  startsAt: "",
  endsAt: "",
});

// ─── Helpers ──────────────────────────────────────────────────────────────────

const toDatetimeLocal = (iso: string) => {
  if (!iso) return "";
  return new Date(iso).toISOString().slice(0, 16);
};

const toISO = (local: string) => {
  if (!local) return "";
  return new Date(local).toISOString();
};

// ─── Media Uploader ───────────────────────────────────────────────────────────

function MediaUploader({
  type,
  currentUrl,
  onMediaReady,
}: {
  type: "image" | "video";
  currentUrl?: string | null;
  onMediaReady: (url: string) => void;
}) {
  const [preview, setPreview] = useState<string | null>(currentUrl ?? null);
  const [isUploading, setIsUploading] = useState(false);
  const [isDragging, setIsDragging] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const presignMutation = usePresignBannerMedia();

  const handleFile = useCallback(
    async (file: File) => {
      if (!file.type.startsWith(`${type}/`)) {
        toast.error(`Please select a valid ${type} file`);
        return;
      }
      if (file.size > 50 * 1024 * 1024) {
        toast.error(`${type === "video" ? "Video" : "Image"} must be smaller than 50 MB`);
        return;
      }

      setIsUploading(true);
      try {
        const { uploadUrl, publicUrl } = await presignMutation.mutateAsync(file.type);
        await axios.put(uploadUrl, file, { headers: { "Content-Type": file.type } });
        setPreview(URL.createObjectURL(file));
        onMediaReady(publicUrl);
        toast.success(`${type === "image" ? "Image" : "Video"} uploaded successfully`);
      } catch {
        toast.error("Upload failed. Please try again.");
      } finally {
        setIsUploading(false);
      }
    },
    [presignMutation, onMediaReady, type]
  );

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) handleFile(file);
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
    const file = e.dataTransfer.files?.[0];
    if (file) handleFile(file);
  };

  const clearMedia = () => {
    setPreview(null);
    onMediaReady("");
    if (fileInputRef.current) fileInputRef.current.value = "";
  };

  return (
    <div className="space-y-3">
      <div
        className={`relative rounded-xl border-2 border-dashed transition-colors ${isDragging
          ? "border-primary bg-primary/5"
          : "border-muted-foreground/25 hover:border-muted-foreground/50"
          } ${isUploading ? "pointer-events-none" : "cursor-pointer"}`}
        style={{ height: "140px" }}
        onClick={() => !isUploading && fileInputRef.current?.click()}
        onDragOver={(e) => { e.preventDefault(); setIsDragging(true); }}
        onDragLeave={() => setIsDragging(false)}
        onDrop={handleDrop}
      >
        {preview ? (
          <>
            {type === "image" ? (
              <img src={preview} alt="Preview" className="w-full h-full object-cover rounded-xl" />
            ) : (
              <video src={preview} className="w-full h-full object-cover rounded-xl" controls />
            )}
            {!isUploading && (
              <button
                type="button"
                onClick={(e) => { e.stopPropagation(); clearMedia(); }}
                className="absolute top-2 right-2 bg-black/60 hover:bg-black/80 text-white rounded-full p-1 transition-colors"
              >
                <X className="w-4 h-4" />
              </button>
            )}
          </>
        ) : (
          <div className="flex flex-col items-center justify-center h-full gap-2 text-muted-foreground">
            {isUploading ? (
              <>
                <Loader2 className="w-8 h-8 animate-spin text-primary" />
                <span className="text-sm">Uploading…</span>
              </>
            ) : (
              <>
                <div className="bg-muted rounded-full p-3">
                  {type === "image" ? <ImageIcon className="w-6 h-6" /> : <Video className="w-6 h-6" />}
                </div>
                <span className="text-sm font-medium">Click or drag {type} here</span>
              </>
            )}
          </div>
        )}
      </div>

      <input
        ref={fileInputRef}
        type="file"
        accept={`${type}/*`}
        className="hidden"
        onChange={handleInputChange}
      />
    </div>
  );
}

// ─── Page ─────────────────────────────────────────────────────────────────────

export default function BannerAdsPage() {
  const [statusFilter, setStatusFilter] = useState<string>("all");
  const [createOpen, setCreateOpen] = useState(false);
  const [editAd, setEditAd] = useState<BannerAd | null>(null);
  const [deleteAd, setDeleteAd] = useState<BannerAd | null>(null);
  const [form, setForm] = useState<CreateBannerAdPayload>(emptyForm());

  // ── Data ───────────────────────────────────────────────────────────────────
  const { data, isLoading, isError } = useBannerAds({
    status: statusFilter !== "all" ? (statusFilter as BannerAdStatus) : undefined,
    page: 1, limit: 50,
  });

  const { data: citiesData } = useCities();
  const { data: sellersData } = useSellers({ page: 1, limit: 50 });

  const ads = data?.data || [];
  const cities = citiesData?.data || [];
  const sellers = sellersData?.data || [];

  // ── Stats ──────────────────────────────────────────────────────────────────
  const totalAds = data?.meta?.total ?? 0;
  const activeCount = ads.filter((a) => a.status === "ACTIVE").length;
  const totalImpr = ads.reduce((s, a) => s + a.impressions, 0);
  const totalClicks = ads.reduce((s, a) => s + a.clicks, 0);

  // ── Mutations ──────────────────────────────────────────────────────────────
  const createMutation = useCreateBannerAd();
  const updateMutation = useUpdateBannerAd();
  const pauseMutation = usePauseBannerAd();
  const resumeMutation = useResumeBannerAd();
  const deleteMutation = useDeleteBannerAd();

  // ── Form helpers ───────────────────────────────────────────────────────────
  const setField = <K extends keyof CreateBannerAdPayload>(key: K, val: CreateBannerAdPayload[K]) =>
    setForm((p) => ({ ...p, [key]: val }));

  const toggleCity = (cityId: string) =>
    setField(
      "cityIds",
      form.cityIds.includes(cityId)
        ? form.cityIds.filter((id) => id !== cityId)
        : [...form.cityIds, cityId]
    );

  const openCreate = () => { setForm(emptyForm()); setCreateOpen(true); };

  const openEdit = (ad: BannerAd) => {
    setForm({
      title: ad.title,
      sellerId: ad.sellerId ?? undefined,
      imageUrl: ad.imageUrl ?? "",
      videoUrl: ad.videoUrl ?? "",
      actionUrl: ad.actionUrl ?? "",
      cityIds: ad.cities.map((c) => c.cityId),
      startsAt: toDatetimeLocal(ad.startsAt),
      endsAt: toDatetimeLocal(ad.endsAt),
    });
    setEditAd(ad);
  };

  // ── Submit ─────────────────────────────────────────────────────────────────
  const handleSubmit = () => {
    const payload = {
      ...form,
      imageUrl: form.imageUrl || undefined,
      videoUrl: form.videoUrl || undefined,
      actionUrl: form.actionUrl || undefined,
      sellerId: form.sellerId || undefined,
      startsAt: toISO(form.startsAt),
      endsAt: toISO(form.endsAt),
    };

    if (!payload.imageUrl && !payload.videoUrl) {
      toast.error("Provide at least one of Image URL or Video URL");
      return;
    }
    if (!payload.cityIds.length) {
      toast.error("Select at least one city");
      return;
    }

    if (editAd) {
      updateMutation.mutate(
        { id: editAd.id, data: payload as UpdateBannerAdPayload },
        {
          onSuccess: () => { toast.success("Ad updated"); setEditAd(null); },
          onError: (e: any) => toast.error(e.response?.data?.message || "Update failed"),
        }
      );
    } else {
      createMutation.mutate(payload as CreateBannerAdPayload, {
        onSuccess: () => { toast.success("Ad created"); setCreateOpen(false); },
        onError: (e: any) => toast.error(e.response?.data?.message || "Create failed"),
      });
    }
  };

  const isSaving = createMutation.isPending || updateMutation.isPending;

  // ── Form dialog (shared create/edit) ──────────────────────────────────────
  const FormDialog = (
    <Dialog open={createOpen || !!editAd} onOpenChange={(o) => { if (!o) { setCreateOpen(false); setEditAd(null); } }}>
      <DialogContent className="rounded-xl sm:max-w-lg max-h-[92vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>{editAd ? `Edit — ${editAd.title}` : "Create Banner Ad"}</DialogTitle>
        </DialogHeader>

        <div className="space-y-4 py-2">
          {/* Title */}
          <div>
            <Label className="text-sm font-medium">Title *</Label>
            <Input
              className="mt-1.5 rounded-lg"
              placeholder="Diwali Sale – Pizza Palace"
              value={form.title}
              onChange={(e) => setField("title", e.target.value)}
            />
          </div>

          {/* Seller (optional) */}
          <div>
            <Label className="text-sm font-medium">Seller (optional)</Label>
            <Select
              value={form.sellerId || "none"}
              onValueChange={(v) => setField("sellerId", v === "none" ? undefined : v)}
            >
              <SelectTrigger className="mt-1.5 rounded-lg">
                <SelectValue placeholder="Select seller…" />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="none">No seller</SelectItem>
                {sellers.map((s) => (
                  <SelectItem key={s.id} value={s.id}>{s.businessName}</SelectItem>
                ))}
              </SelectContent>
            </Select>
          </div>

          {/* Image URL */}
          <div>
            <Label className="text-sm font-medium">Image (Optional)</Label>
            <MediaUploader
              type="image"
              currentUrl={form.imageUrl}
              onMediaReady={(url) => setField("imageUrl", url)}
            />
          </div>

          {/* Video URL */}
          <div>
            <Label className="text-sm font-medium">Video (Optional)</Label>
            <MediaUploader
              type="video"
              currentUrl={form.videoUrl}
              onMediaReady={(url) => setField("videoUrl", url)}
            />
            <p className="text-[11px] text-muted-foreground mt-1">At least one of Image or Video is required.</p>
          </div>

          {/* Action URL */}
          <div>
            <Label className="text-sm font-medium">Action URL (tap destination)</Label>
            <Input
              className="mt-1.5 rounded-lg"
              placeholder="https://…/seller/abc"
              value={form.actionUrl || ""}
              onChange={(e) => setField("actionUrl", e.target.value)}
            />
          </div>

          {/* Campaign dates */}
          <div className="grid grid-cols-2 gap-3">
            <div>
              <Label className="text-sm font-medium">Starts At *</Label>
              <Input
                type="datetime-local"
                className="mt-1.5 rounded-lg"
                value={form.startsAt}
                onChange={(e) => setField("startsAt", e.target.value)}
              />
            </div>
            <div>
              <Label className="text-sm font-medium">Ends At *</Label>
              <Input
                type="datetime-local"
                className="mt-1.5 rounded-lg"
                value={form.endsAt}
                onChange={(e) => setField("endsAt", e.target.value)}
              />
            </div>
          </div>

          {/* Status (edit only) */}
          {editAd && (
            <div>
              <Label className="text-sm font-medium">Status</Label>
              <Select
                value={(form as any).status || editAd.status}
                onValueChange={(v) => setForm((p) => ({ ...p, status: v as BannerAdStatus } as any))}
              >
                <SelectTrigger className="mt-1.5 rounded-lg">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="ACTIVE">Active</SelectItem>
                  <SelectItem value="PAUSED">Paused</SelectItem>
                  <SelectItem value="COMPLETED">Completed</SelectItem>
                </SelectContent>
              </Select>
            </div>
          )}

          {/* City selection */}
          <div>
            <Label className="text-sm font-medium">Target Cities *</Label>
            <div className="mt-2 grid grid-cols-2 gap-2 max-h-44 overflow-y-auto rounded-lg border p-3">
              {cities.map((city) => (
                <label key={city.id} className="flex items-center gap-2 cursor-pointer">
                  <Checkbox
                    checked={form.cityIds.includes(city.id)}
                    onCheckedChange={() => toggleCity(city.id)}
                  />
                  <span className="text-sm">{city.name}</span>
                </label>
              ))}
              {cities.length === 0 && (
                <p className="text-sm text-muted-foreground col-span-2 text-center py-2">Loading cities…</p>
              )}
            </div>
            <p className="text-[11px] text-muted-foreground mt-1">
              {form.cityIds.length} city/cities selected
            </p>
          </div>
        </div>

        <DialogFooter>
          <Button variant="outline" className="rounded-lg" onClick={() => { setCreateOpen(false); setEditAd(null); }}>
            Cancel
          </Button>
          <Button className="rounded-lg" disabled={isSaving} onClick={handleSubmit}>
            {isSaving ? <Loader2 className="h-4 w-4 animate-spin" /> : editAd ? "Save Changes" : "Create Ad"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );

  // ─────────────────────────────────────────────────────────────────────────────

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between animate-in-view">
        <div>
          <h1 className="text-2xl md:text-3xl font-bold tracking-tight">Banner Ads</h1>
          <p className="text-muted-foreground mt-1">{totalAds} campaigns</p>
        </div>
        <Button className="rounded-lg gap-2" onClick={openCreate}>
          <Plus className="h-4 w-4" />
          New Ad
        </Button>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 animate-in-view" style={{ animationDelay: "60ms" }}>
        {[
          { label: "Total Ads", value: totalAds, icon: Image, color: "bg-[hsl(230,60%,96%)] text-[hsl(230,60%,50%)]" },
          { label: "Active Now", value: activeCount, icon: BarChart2, color: "bg-[hsl(145,50%,95%)] text-[hsl(170,60%,42%)]" },
          { label: "Impressions", value: totalImpr, icon: Eye, color: "bg-[hsl(35,80%,95%)]  text-[hsl(35,92%,42%)]" },
          { label: "Clicks", value: totalClicks, icon: MousePointerClick, color: "bg-[hsl(290,50%,96%)] text-[hsl(290,50%,50%)]" },
        ].map(({ label, value, icon: Icon, color }) => (
          <Card key={label} className="border-0 shadow-sm">
            <CardContent className="p-4 flex items-center gap-3">
              <div className={`p-2 rounded-lg ${color.split(" ")[0]}`}>
                <Icon className={`h-4 w-4 ${color.split(" ")[1]}`} />
              </div>
              <div>
                <p className="text-2xl font-bold tabular-nums">{value.toLocaleString()}</p>
                <p className="text-xs text-muted-foreground">{label}</p>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* Filter */}
      <div className="flex gap-3 animate-in-view" style={{ animationDelay: "120ms" }}>
        <Select value={statusFilter} onValueChange={setStatusFilter}>
          <SelectTrigger className="w-40 rounded-lg h-10">
            <SelectValue placeholder="Status" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Status</SelectItem>
            <SelectItem value="ACTIVE">Active</SelectItem>
            <SelectItem value="PAUSED">Paused</SelectItem>
            <SelectItem value="COMPLETED">Completed</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {/* Table */}
      <Card className="border-0 shadow-sm overflow-hidden animate-in-view" style={{ animationDelay: "180ms" }}>
        <Table>
          <TableHeader>
            <TableRow className="bg-muted/50 hover:bg-muted/50">
              <TableHead className="font-semibold">Ad</TableHead>
              <TableHead className="hidden md:table-cell font-semibold">Seller</TableHead>
              <TableHead className="hidden lg:table-cell font-semibold">Cities</TableHead>
              <TableHead className="hidden lg:table-cell font-semibold">Campaign</TableHead>
              <TableHead className="hidden md:table-cell font-semibold text-right">Stats</TableHead>
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
                <TableCell colSpan={7} className="text-center py-12 text-destructive font-medium">
                  Failed to load ads. Please try again.
                </TableCell>
              </TableRow>
            )}

            {!isLoading && !isError && ads.map((ad) => (
              <TableRow key={ad.id} className="hover:bg-accent/40 transition-colors">
                {/* Ad preview */}
                <TableCell>
                  <div className="flex items-center gap-3">
                    {ad.imageUrl ? (
                      <img
                        src={ad.imageUrl}
                        alt={ad.title}
                        className="h-10 w-16 object-cover rounded-lg shrink-0 bg-muted"
                        onError={(e) => { (e.target as HTMLImageElement).style.display = "none"; }}
                      />
                    ) : (
                      <div className="h-10 w-16 rounded-lg bg-muted flex items-center justify-center shrink-0">
                        <Image className="h-4 w-4 text-muted-foreground" />
                      </div>
                    )}
                    <span className="font-medium text-sm line-clamp-1 max-w-[160px]">{ad.title}</span>
                  </div>
                </TableCell>

                {/* Seller */}
                <TableCell className="hidden md:table-cell text-muted-foreground text-sm">
                  {ad.seller?.businessName || <span className="italic text-muted-foreground/60">—</span>}
                </TableCell>

                {/* Cities */}
                <TableCell className="hidden lg:table-cell">
                  <div className="flex items-center gap-1 text-sm text-muted-foreground">
                    <MapPin className="h-3.5 w-3.5 shrink-0" />
                    <span className="truncate max-w-[140px]">
                      {ad.cities.map((c) => c.city.name).join(", ") || "—"}
                    </span>
                  </div>
                </TableCell>

                {/* Campaign dates */}
                <TableCell className="hidden lg:table-cell">
                  <div className="text-xs text-muted-foreground space-y-0.5">
                    <div className="flex items-center gap-1">
                      <CalendarDays className="h-3 w-3" />
                      <span>{format(new Date(ad.startsAt), "dd MMM yy")}</span>
                    </div>
                    <div className="flex items-center gap-1 text-muted-foreground/60">
                      <span className="ml-4">→ {format(new Date(ad.endsAt), "dd MMM yy")}</span>
                    </div>
                  </div>
                </TableCell>

                {/* Stats */}
                <TableCell className="hidden md:table-cell text-right">
                  <div className="text-xs text-muted-foreground space-y-0.5">
                    <div className="flex items-center justify-end gap-1">
                      <Eye className="h-3 w-3" />
                      <span className="tabular-nums">{ad.impressions.toLocaleString()}</span>
                    </div>
                    <div className="flex items-center justify-end gap-1">
                      <MousePointerClick className="h-3 w-3" />
                      <span className="tabular-nums">{ad.clicks.toLocaleString()}</span>
                    </div>
                  </div>
                </TableCell>

                {/* Status */}
                <TableCell>
                  <Badge variant="secondary" className={`${statusStyle[ad.status]} font-medium`}>
                    {ad.status}
                  </Badge>
                </TableCell>

                {/* Actions */}
                <TableCell className="text-right">
                  <div className="flex justify-end gap-1">
                    {ad.status === "ACTIVE" && (
                      <Button
                        size="icon" variant="ghost"
                        className="h-8 w-8 rounded-lg hover:bg-accent"
                        title="Pause"
                        disabled={pauseMutation.isPending}
                        onClick={() => pauseMutation.mutate(ad.id, {
                          onSuccess: () => toast.success(`Paused "${ad.title}"`),
                          onError: (e: any) => toast.error(e.response?.data?.message || "Failed to pause"),
                        })}
                      >
                        {pauseMutation.isPending && pauseMutation.variables === ad.id
                          ? <Loader2 className="h-4 w-4 animate-spin" />
                          : <Pause className="h-4 w-4 text-muted-foreground" />}
                      </Button>
                    )}
                    {ad.status === "PAUSED" && (
                      <Button
                        size="icon" variant="ghost"
                        className="h-8 w-8 rounded-lg hover:bg-accent"
                        title="Resume"
                        disabled={resumeMutation.isPending}
                        onClick={() => resumeMutation.mutate(ad.id, {
                          onSuccess: () => toast.success(`Resumed "${ad.title}"`),
                          onError: (e: any) => toast.error(e.response?.data?.message || "Failed to resume"),
                        })}
                      >
                        {resumeMutation.isPending && resumeMutation.variables === ad.id
                          ? <Loader2 className="h-4 w-4 animate-spin" />
                          : <Play className="h-4 w-4 text-muted-foreground" />}
                      </Button>
                    )}
                    <Button
                      size="icon" variant="ghost"
                      className="h-8 w-8 rounded-lg hover:bg-accent"
                      title="Edit"
                      onClick={() => openEdit(ad)}
                    >
                      <Pencil className="h-4 w-4" />
                    </Button>
                    <Button
                      size="icon" variant="ghost"
                      className="h-8 w-8 rounded-lg text-destructive hover:bg-destructive/10"
                      title="Delete"
                      onClick={() => setDeleteAd(ad)}
                    >
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </div>
                </TableCell>
              </TableRow>
            ))}

            {!isLoading && !isError && ads.length === 0 && (
              <TableRow>
                <TableCell colSpan={7} className="text-center py-12 text-muted-foreground">
                  No banner ads yet. Create your first one!
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </Card>

      {/* Create / Edit dialog */}
      {FormDialog}

      {/* Delete confirm */}
      <AlertDialog open={!!deleteAd} onOpenChange={(o) => !o && setDeleteAd(null)}>
        <AlertDialogContent className="rounded-xl">
          <AlertDialogHeader>
            <AlertDialogTitle>Delete Ad</AlertDialogTitle>
            <AlertDialogDescription>
              Are you sure you want to permanently delete <strong>"{deleteAd?.title}"</strong>?
              This action cannot be undone.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel className="rounded-lg">Cancel</AlertDialogCancel>
            <AlertDialogAction
              className="rounded-lg bg-destructive hover:bg-destructive/90"
              onClick={() => {
                if (!deleteAd) return;
                deleteMutation.mutate(deleteAd.id, {
                  onSuccess: () => { toast.success(`Deleted "${deleteAd.title}"`); setDeleteAd(null); },
                  onError: (e: any) => toast.error(e.response?.data?.message || "Delete failed"),
                });
              }}
            >
              {deleteMutation.isPending ? <Loader2 className="h-4 w-4 animate-spin" /> : "Delete"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
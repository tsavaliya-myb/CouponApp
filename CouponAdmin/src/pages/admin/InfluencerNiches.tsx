import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter, DialogDescription } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { Pencil, Plus, Trash2 } from "lucide-react";
import { useInfluencerNiches, useCreateInfluencerNiche, useUpdateInfluencerNiche, useDeleteInfluencerNiche } from "@/hooks/api/useInfluencers";
import { toast } from "sonner";

export default function InfluencerNichesPage() {
  const { data: nichesRes, isLoading } = useInfluencerNiches();
  const createMutation = useCreateInfluencerNiche();
  const updateMutation = useUpdateInfluencerNiche();
  const deleteMutation = useDeleteInfluencerNiche();

  const niches = nichesRes?.data || [];

  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingNiche, setEditingNiche] = useState<any>(null);
  
  const [formData, setFormData] = useState({
    name: "",
    slug: "",
    isActive: true,
    sortOrder: 0,
  });

  const handleOpenDialog = (niche?: any) => {
    if (niche) {
      setEditingNiche(niche);
      setFormData({
        name: niche.name,
        slug: niche.slug,
        isActive: niche.isActive,
        sortOrder: niche.sortOrder,
      });
    } else {
      setEditingNiche(null);
      setFormData({
        name: "",
        slug: "",
        isActive: true,
        sortOrder: niches.length,
      });
    }
    setDialogOpen(true);
  };

  const handleSave = async () => {
    try {
      if (editingNiche) {
        await updateMutation.mutateAsync({ id: editingNiche.id, ...formData });
        toast.success("Niche updated successfully");
      } else {
        await createMutation.mutateAsync(formData);
        toast.success("Niche created successfully");
      }
      setDialogOpen(false);
    } catch (e: any) {
      toast.error(e.response?.data?.error || "Failed to save niche");
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm("Are you sure you want to delete this niche?")) return;
    try {
      await deleteMutation.mutateAsync(id);
      toast.success("Niche deleted successfully");
    } catch (e: any) {
      toast.error(e.response?.data?.error || "Failed to delete niche");
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold tracking-tight text-[hsl(220,40%,20%)]">Influencer Niches</h1>
          <p className="text-muted-foreground">Manage categories for influencers.</p>
        </div>
        <Button onClick={() => handleOpenDialog()}>
          <Plus className="mr-2 h-4 w-4" /> Add Niche
        </Button>
      </div>

      <div className="rounded-xl border bg-card overflow-hidden">
        <Table>
          <TableHeader className="bg-muted/50">
            <TableRow>
              <TableHead>Sort Order</TableHead>
              <TableHead>Name</TableHead>
              <TableHead>Slug</TableHead>
              <TableHead>Influencers</TableHead>
              <TableHead>Active</TableHead>
              <TableHead className="text-right">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {isLoading ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-8 text-muted-foreground">
                  Loading...
                </TableCell>
              </TableRow>
            ) : niches.length === 0 ? (
              <TableRow>
                <TableCell colSpan={6} className="text-center py-8 text-muted-foreground">
                  No niches found
                </TableCell>
              </TableRow>
            ) : (
              niches.map((niche: any) => (
                <TableRow key={niche.id}>
                  <TableCell>{niche.sortOrder}</TableCell>
                  <TableCell className="font-medium">{niche.name}</TableCell>
                  <TableCell>{niche.slug}</TableCell>
                  <TableCell>{niche._count?.influencers || 0}</TableCell>
                  <TableCell>
                    <Switch 
                      checked={niche.isActive} 
                      onCheckedChange={(val) => {
                        updateMutation.mutate({ id: niche.id, isActive: val });
                      }}
                    />
                  </TableCell>
                  <TableCell className="text-right">
                    <Button variant="ghost" size="icon" onClick={() => handleOpenDialog(niche)}>
                      <Pencil className="h-4 w-4" />
                    </Button>
                    <Button variant="ghost" size="icon" className="text-red-500" onClick={() => handleDelete(niche.id)}>
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>

      <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{editingNiche ? "Edit Niche" : "Add Niche"}</DialogTitle>
            <DialogDescription>Define a category for influencers.</DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <div className="space-y-2">
              <Label>Name</Label>
              <Input 
                value={formData.name} 
                onChange={e => {
                  const val = e.target.value;
                  setFormData(prev => ({
                    ...prev,
                    name: val,
                    slug: !editingNiche ? val.toLowerCase().replace(/[^a-z0-9]+/g, '-') : prev.slug
                  }))
                }} 
              />
            </div>
            <div className="space-y-2">
              <Label>Slug</Label>
              <Input 
                value={formData.slug} 
                onChange={e => setFormData(prev => ({ ...prev, slug: e.target.value }))} 
              />
            </div>
            <div className="space-y-2">
              <Label>Sort Order</Label>
              <Input 
                type="number"
                value={formData.sortOrder} 
                onChange={e => setFormData(prev => ({ ...prev, sortOrder: parseInt(e.target.value) || 0 }))} 
              />
            </div>
            <div className="flex items-center gap-2">
              <Switch 
                checked={formData.isActive}
                onCheckedChange={val => setFormData(prev => ({ ...prev, isActive: val }))}
              />
              <Label>Active</Label>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDialogOpen(false)}>Cancel</Button>
            <Button onClick={handleSave} disabled={createMutation.isPending || updateMutation.isPending}>
              Save Niche
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}

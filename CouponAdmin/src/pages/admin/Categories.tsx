import { useState, useMemo, useCallback, useRef } from "react";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Plus, Edit2, GripHorizontal, Upload, X, ImageIcon, Loader2 } from "lucide-react";
import { useCategories, useCreateCategory, useUpdateCategory, useReorderCategories, usePresignCategoryImage } from "@/hooks/api/useCategories";
import { Category } from "@/types/api/category";
import { toast } from "sonner";
import axios from "axios";
import {
  DndContext,
  closestCenter,
  KeyboardSensor,
  PointerSensor,
  useSensor,
  useSensors,
  DragEndEvent
} from '@dnd-kit/core';
import {
  arrayMove,
  SortableContext,
  sortableKeyboardCoordinates,
  rectSortingStrategy,
  useSortable,
} from '@dnd-kit/sortable';
import { CSS } from '@dnd-kit/utilities';

// ─── Image Upload Component ───────────────────────────────────────────────────

function ImageUploader({
  currentImageUrl,
  onImageReady,
}: {
  currentImageUrl?: string | null;
  onImageReady: (url: string) => void;
}) {
  const [preview, setPreview] = useState<string | null>(currentImageUrl ?? null);
  const [isUploading, setIsUploading] = useState(false);
  const [isDragging, setIsDragging] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);
  const presignMutation = usePresignCategoryImage();

  const handleFile = useCallback(
    async (file: File) => {
      if (!file.type.startsWith("image/")) {
        toast.error("Please select an image file (JPEG, PNG, WebP, GIF)");
        return;
      }
      if (file.size > 5 * 1024 * 1024) {
        toast.error("Image must be smaller than 5 MB");
        return;
      }

      setIsUploading(true);
      try {
        // 1. Get presigned upload URL from our API
        const { uploadUrl, publicUrl } = await presignMutation.mutateAsync(file.type);

        // 2. Upload directly to S3 via presigned PUT
        await axios.put(uploadUrl, file, {
          headers: { "Content-Type": file.type },
        });

        // 3. Store the permanent proxy URL
        setPreview(URL.createObjectURL(file));
        onImageReady(publicUrl);
        toast.success("Image uploaded successfully");
      } catch {
        toast.error("Image upload failed. Please try again.");
      } finally {
        setIsUploading(false);
      }
    },
    [presignMutation, onImageReady]
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

  const clearImage = () => {
    setPreview(null);
    onImageReady("");
    if (fileInputRef.current) fileInputRef.current.value = "";
  };

  return (
    <div className="space-y-3">
      <Label>Background Image</Label>

      {/* Dropzone / Preview area */}
      <div
        className={`relative rounded-xl border-2 border-dashed transition-colors ${
          isDragging
            ? "border-primary bg-primary/5"
            : "border-muted-foreground/25 hover:border-muted-foreground/50"
        } ${isUploading ? "pointer-events-none" : "cursor-pointer"}`}
        style={{ height: "160px" }}
        onClick={() => !isUploading && fileInputRef.current?.click()}
        onDragOver={(e) => { e.preventDefault(); setIsDragging(true); }}
        onDragLeave={() => setIsDragging(false)}
        onDrop={handleDrop}
      >
        {preview ? (
          <>
            <img
              src={preview}
              alt="Category background"
              className="w-full h-full object-cover rounded-xl"
            />
            {/* Overlay: category name preview */}
            <div className="absolute inset-0 rounded-xl bg-gradient-to-t from-black/60 via-transparent to-transparent flex items-end p-4">
              <span className="text-white font-bold text-lg drop-shadow">Category Name</span>
            </div>
            {/* Remove button */}
            {!isUploading && (
              <button
                type="button"
                onClick={(e) => { e.stopPropagation(); clearImage(); }}
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
                  <ImageIcon className="w-6 h-6" />
                </div>
                <span className="text-sm font-medium">Click or drag an image here</span>
                <span className="text-xs">JPEG, PNG, WebP, GIF · Max 5 MB</span>
              </>
            )}
          </div>
        )}
      </div>

      {/* Hidden file input */}
      <input
        ref={fileInputRef}
        type="file"
        accept="image/jpeg,image/png,image/webp,image/gif"
        className="hidden"
        onChange={handleInputChange}
      />

      {/* Replace button when image exists */}
      {preview && !isUploading && (
        <Button
          type="button"
          variant="outline"
          size="sm"
          className="w-full"
          onClick={() => fileInputRef.current?.click()}
        >
          <Upload className="mr-2 h-4 w-4" />
          Replace Image
        </Button>
      )}
    </div>
  );
}

// ─── Category Form Dialog ─────────────────────────────────────────────────────

function CategoryFormDialog({
  isOpen,
  onClose,
  initialData
}: {
  isOpen: boolean;
  onClose: () => void;
  initialData?: Category | null;
}) {
  const isEditing = !!initialData;
  const [name, setName] = useState(initialData?.name || "");
  const [subtitle, setSubtitle] = useState(initialData?.subtitle || "");
  const [imageUrl, setImageUrl] = useState(initialData?.imageUrl || "");
  const [isActive, setIsActive] = useState(initialData?.isActive ?? true);

  const createMutation = useCreateCategory();
  const updateMutation = useUpdateCategory();

  const isPending = createMutation.isPending || updateMutation.isPending;

  const handleSubmit = () => {
    if (!name.trim()) return toast.error("Name is required");

    const payload = {
      name: name.trim(),
      subtitle: subtitle.trim() || undefined,
      imageUrl: imageUrl || undefined,
      ...(isEditing ? { isActive } : {}),
    };

    if (isEditing && initialData) {
      updateMutation.mutate(
        { id: initialData.id, data: payload },
        { onSuccess: onClose }
      );
    } else {
      createMutation.mutate(payload, { onSuccess: onClose });
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="max-w-lg">
        <DialogHeader>
          <DialogTitle>{isEditing ? "Edit Category" : "Add New Category"}</DialogTitle>
        </DialogHeader>
        <div className="space-y-5 py-2">
          {/* Name */}
          <div className="space-y-2">
            <Label>Name *</Label>
            <Input
              placeholder="e.g. Food & Drinks"
              value={name}
              onChange={e => setName(e.target.value)}
            />
          </div>

          {/* Subtitle */}
          <div className="space-y-2">
            <Label>Subtitle</Label>
            <Input
              placeholder="e.g. Craving for something delicious?"
              value={subtitle}
              onChange={e => setSubtitle(e.target.value)}
            />
          </div>

          {/* Image Upload */}
          <ImageUploader
            currentImageUrl={initialData?.imageUrl}
            onImageReady={setImageUrl}
          />

          {/* Active Status (edit only) */}
          {isEditing && (
            <div className="flex items-center justify-between py-2 border-y">
              <Label>Active Status</Label>
              <Switch checked={isActive} onCheckedChange={setIsActive} />
            </div>
          )}
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button onClick={handleSubmit} disabled={isPending}>
            {isPending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
            {isEditing ? "Save Changes" : "Create Category"}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

// ─── Sortable Category Card ───────────────────────────────────────────────────

function SortableCategoryCard({
  category,
  onToggleStatus,
  onEdit
}: {
  category: Category;
  onToggleStatus: (id: string, status: boolean) => void;
  onEdit: (cat: Category) => void;
}) {
  const {
    attributes,
    listeners,
    setNodeRef,
    transform,
    transition,
    isDragging
  } = useSortable({ id: category.id });

  const style = {
    transform: CSS.Transform.toString(transform),
    transition,
    zIndex: isDragging ? 10 : 1,
  };

  return (
    <Card
      ref={setNodeRef}
      style={style}
      className={`relative overflow-hidden transition-all ${!category.isActive ? 'opacity-60 grayscale' : ''} ${isDragging ? 'shadow-xl scale-105 opacity-80' : ''}`}
    >
      {/* Image / Placeholder header */}
      <div className="relative h-28 group bg-muted">
        {category.imageUrl ? (
          <img
            src={category.imageUrl}
            alt={category.name}
            className="w-full h-full object-cover"
          />
        ) : (
          <div className="w-full h-full flex items-center justify-center bg-gradient-to-br from-muted to-muted/50">
            <ImageIcon className="w-8 h-8 text-muted-foreground/40" />
          </div>
        )}
        {/* Gradient overlay for text readability */}
        <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent" />

        {/* Drag handle */}
        <button
          {...attributes}
          {...listeners}
          className="absolute top-2 right-2 p-1.5 bg-black/20 hover:bg-black/40 rounded-md cursor-grab active:cursor-grabbing opacity-0 group-hover:opacity-100 transition-opacity"
        >
          <GripHorizontal className="w-4 h-4 text-white" />
        </button>

        {/* Category name overlay */}
        <div className="absolute bottom-0 left-0 right-0 p-3">
          <h3 className="font-bold text-white leading-tight line-clamp-1 drop-shadow">
            {category.name}
          </h3>
          {category.subtitle && (
            <p className="text-xs text-white/80 mt-0.5 line-clamp-1 drop-shadow">
              {category.subtitle}
            </p>
          )}
        </div>
      </div>

      <CardContent className="p-4 bg-card flex items-center justify-between">
        <div className="flex items-center gap-2">
          <Switch
            checked={category.isActive}
            onCheckedChange={() => onToggleStatus(category.id, category.isActive)}
          />
          <span className="text-sm font-medium text-muted-foreground">
            {category.isActive ? 'Active' : 'Inactive'}
          </span>
        </div>
        <Button variant="ghost" size="icon" onClick={() => onEdit(category)}>
          <Edit2 className="h-4 w-4" />
        </Button>
      </CardContent>
    </Card>
  );
}

// ─── Main Page ────────────────────────────────────────────────────────────────

export default function CategoriesPage() {
  const { data: categories = [], isLoading } = useCategories();
  const updateMutation = useUpdateCategory();
  const reorderMutation = useReorderCategories();

  const [formDialog, setFormDialog] = useState<{ open: boolean; data?: Category | null }>({ open: false });

  const sensors = useSensors(
    useSensor(PointerSensor, {
      activationConstraint: {
        distance: 5,
      },
    }),
    useSensor(KeyboardSensor, {
      coordinateGetter: sortableKeyboardCoordinates,
    })
  );

  const toggleStatus = (id: string, currentStatus: boolean) => {
    updateMutation.mutate({ id, data: { isActive: !currentStatus } });
  };

  const handleDragEnd = (event: DragEndEvent) => {
    const { active, over } = event;

    if (over && active.id !== over.id) {
      const oldIndex = categories.findIndex((c) => c.id === active.id);
      const newIndex = categories.findIndex((c) => c.id === over.id);

      const newArray = arrayMove(categories, oldIndex, newIndex);
      const newOrderIds = newArray.map(c => c.id);

      reorderMutation.mutate(newOrderIds);
    }
  };

  const categoryIds = useMemo(() => categories.map(c => c.id), [categories]);

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h2 className="text-3xl font-bold tracking-tight">Categories</h2>
          <p className="text-muted-foreground">Manage app categories, their background images and visibility. Drag to reorder.</p>
        </div>
        <Button onClick={() => setFormDialog({ open: true })}>
          <Plus className="mr-2 h-4 w-4" /> Add Category
        </Button>
      </div>

      {isLoading ? (
        <div className="flex justify-center p-12">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
        </div>
      ) : categories.length === 0 ? (
        <Card>
          <CardContent className="flex flex-col items-center justify-center py-16 text-center">
            <div className="bg-muted rounded-full p-4 mb-4">
              <ImageIcon className="w-8 h-8 text-muted-foreground" />
            </div>
            <CardTitle className="mb-2">No categories yet</CardTitle>
            <CardDescription className="mb-6">Create your first category to organize coupons.</CardDescription>
            <Button onClick={() => setFormDialog({ open: true })}>Create Category</Button>
          </CardContent>
        </Card>
      ) : (
        <DndContext
          sensors={sensors}
          collisionDetection={closestCenter}
          onDragEnd={handleDragEnd}
        >
          <SortableContext
            items={categoryIds}
            strategy={rectSortingStrategy}
          >
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
              {categories.map((category) => (
                <SortableCategoryCard
                  key={category.id}
                  category={category}
                  onToggleStatus={toggleStatus}
                  onEdit={(cat) => setFormDialog({ open: true, data: cat })}
                />
              ))}
            </div>
          </SortableContext>
        </DndContext>
      )}

      {formDialog.open && (
        <CategoryFormDialog
          isOpen={formDialog.open}
          initialData={formDialog.data}
          onClose={() => setFormDialog({ open: false })}
        />
      )}
    </div>
  );
}

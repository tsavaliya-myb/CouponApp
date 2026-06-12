import { useState, useMemo } from "react";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Plus, Edit2, Search, GripHorizontal } from "lucide-react";
import { useCategories, useCreateCategory, useUpdateCategory, useReorderCategories } from "@/hooks/api/useCategories";
import { Category } from "@/types/api/category";
import { toast } from "sonner";
import { ScrollArea } from "@/components/ui/scroll-area";
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

import MATERIAL_ICONS from "@/data/material-icons.json";

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
  const [color, setColor] = useState(initialData?.color || "#F9E8D9");
  const [iconName, setIconName] = useState(initialData?.iconName || "restaurant_rounded");
  const [isActive, setIsActive] = useState(initialData?.isActive ?? true);
  
  const [iconSearch, setIconSearch] = useState("");

  const createMutation = useCreateCategory();
  const updateMutation = useUpdateCategory();

  const isPending = createMutation.isPending || updateMutation.isPending;

  const handleSubmit = () => {
    if (!name.trim()) return toast.error("Name is required");
    if (!color.match(/^#[0-9A-Fa-f]{6}$/)) return toast.error("Invalid Hex Color");

    const payload = {
      name: name.trim(),
      subtitle: subtitle.trim() || undefined,
      color,
      iconName,
      isActive
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

  const filteredIcons = MATERIAL_ICONS.filter(i => i.toLowerCase().includes(iconSearch.toLowerCase())).slice(0, 50);

  return (
    <Dialog open={isOpen} onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="max-w-2xl">
        <DialogHeader>
          <DialogTitle>{isEditing ? "Edit Category" : "Add New Category"}</DialogTitle>
        </DialogHeader>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6 py-4">
          <div className="space-y-4">
            <div className="space-y-2">
              <Label>Name</Label>
              <Input placeholder="e.g. Food & Drinks" value={name} onChange={e => setName(e.target.value)} />
            </div>
            <div className="space-y-2">
              <Label>Subtitle</Label>
              <Input placeholder="e.g. Craving for something delicious?" value={subtitle} onChange={e => setSubtitle(e.target.value)} />
            </div>
            <div className="space-y-2">
              <Label>Card Color (Hex)</Label>
              <div className="flex items-center gap-3">
                <Input type="color" className="w-16 p-1 h-10" value={color} onChange={e => setColor(e.target.value)} />
                <Input placeholder="#FFFFFF" value={color} onChange={e => setColor(e.target.value)} className="flex-1" />
              </div>
            </div>
            {isEditing && (
              <div className="flex items-center justify-between py-2 border-y">
                <Label>Active Status</Label>
                <Switch checked={isActive} onCheckedChange={setIsActive} />
              </div>
            )}
          </div>
          
          <div className="space-y-4 border-l pl-6">
            <div>
              <Label className="mb-2 block">Live App Preview</Label>
              <div className="p-4 rounded-xl flex items-center gap-4" style={{ backgroundColor: color }}>
                <div className="bg-black/10 rounded-full w-12 h-12 flex items-center justify-center">
                  <span className="material-symbols-rounded text-2xl" style={{ color: "#D1761F" }}>
                    {iconName.replace('_rounded', '')}
                  </span>
                </div>
                <div>
                  <h3 className="font-bold text-gray-900 leading-tight">{name || "Category Name"}</h3>
                  <p className="text-sm text-gray-700 opacity-80 mt-0.5">{subtitle || "Subtitle goes here"}</p>
                </div>
              </div>
            </div>

            <div className="space-y-2 pt-2">
              <Label>Select Icon</Label>
              <div className="relative">
                <Search className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground" />
                <Input placeholder="Search icon..." className="pl-8" value={iconSearch} onChange={e => setIconSearch(e.target.value)} />
              </div>
              <ScrollArea className="h-[200px] border rounded-md p-2 mt-2">
                <div className="grid grid-cols-4 gap-2">
                  {filteredIcons.map(icon => (
                    <button
                      key={icon}
                      onClick={() => setIconName(icon)}
                      className={`flex flex-col items-center justify-center p-2 rounded-lg border hover:bg-muted/50 transition-colors ${iconName === icon ? 'border-primary bg-primary/10' : 'border-transparent'}`}
                      title={icon}
                    >
                      <span className="material-symbols-rounded text-2xl text-muted-foreground">
                        {icon.replace('_rounded', '')}
                      </span>
                    </button>
                  ))}
                  {filteredIcons.length === 0 && (
                    <div className="col-span-4 text-center py-4 text-sm text-muted-foreground">No icons found.</div>
                  )}
                </div>
                {filteredIcons.length === 50 && (
                  <div className="text-center py-2 mt-2 text-xs text-muted-foreground border-t">
                    Showing first 50 results. Search to narrow down.
                  </div>
                )}
              </ScrollArea>
              <p className="text-xs text-muted-foreground pt-1">Selected: <b>{iconName}</b></p>
            </div>
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>Cancel</Button>
          <Button onClick={handleSubmit} disabled={isPending}>{isEditing ? "Save Changes" : "Create Category"}</Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
}

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
      <div 
        className="h-24 p-4 flex items-center gap-4 border-b group"
        style={{ backgroundColor: category.color || '#F9E8D9' }}
      >
        <button 
          {...attributes} 
          {...listeners}
          className="absolute top-2 right-2 p-1.5 bg-black/5 hover:bg-black/10 rounded-md cursor-grab active:cursor-grabbing opacity-0 group-hover:opacity-100 transition-opacity"
        >
          <GripHorizontal className="w-4 h-4 text-black/50" />
        </button>

        <div className="bg-black/10 rounded-full w-12 h-12 flex items-center justify-center shrink-0">
          <span className="material-symbols-rounded text-2xl" style={{ color: "#D1761F" }}>
            {(category.iconName || 'category').replace('_rounded', '')}
          </span>
        </div>
        <div className="pr-6">
          <h3 className="font-bold text-gray-900 leading-tight line-clamp-1">{category.name}</h3>
          {category.subtitle && (
            <p className="text-sm text-gray-700 opacity-80 mt-0.5 line-clamp-1">{category.subtitle}</p>
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
          <p className="text-muted-foreground">Manage app categories, their styling and visibility. Drag to reorder.</p>
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
              <span className="material-symbols-rounded text-4xl text-muted-foreground">category</span>
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

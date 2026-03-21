import { useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from "@/components/ui/accordion";
import { MapPin, Plus, Building2, Map, Loader2 } from "lucide-react";
import { useCities, useCreateCity, useUpdateCity, useAreas, useCreateArea, useUpdateArea } from "@/hooks/api/useLocation";
import { type City } from "@/types/api/location";
import { toast } from "sonner";

function CityAreaList({ cityId }: { cityId: string }) {
  const { data: areasResp, isLoading } = useAreas(cityId);
  const areas = areasResp?.data || [];
  const updateAreaMutation = useUpdateArea();
  
  const toggleAreaStatus = (areaId: string, currentStatus: boolean) => {
    const toastId = toast.loading("Updating area...");
    updateAreaMutation.mutate(
      { id: areaId, payload: { isActive: !currentStatus } },
      {
        onSuccess: () => toast.success("Area updated", { id: toastId }),
        onError: (err: any) => toast.error(err.response?.data?.message || "Failed to update area", { id: toastId })
      }
    );
  };

  if (isLoading) return <Loader2 className="animate-spin h-4 w-4 mx-auto text-muted-foreground my-6" />;
  if (areas.length === 0) return <p className="text-sm text-center text-muted-foreground py-4">No areas configured.</p>;

  return (
    <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
      {areas.map((area) => (
        <div key={area.id} className="flex items-center justify-between bg-muted/40 rounded-lg px-3 py-2">
          <span className={`text-sm font-medium ${!area.isActive ? "text-muted-foreground line-through" : ""}`}>{area.name}</span>
          <Switch checked={area.isActive} onCheckedChange={() => toggleAreaStatus(area.id, area.isActive)} disabled={updateAreaMutation.isPending} className="scale-75" />
        </div>
      ))}
    </div>
  );
}

export default function CitiesAreasPage() {
  const { data: citiesResp, isLoading: isCitiesLoading } = useCities();
  const citiesData = citiesResp?.data || [];
  const createCityMutation = useCreateCity();
  const updateCityMutation = useUpdateCity();
  const createAreaMutation = useCreateArea();

  const [addCityOpen, setAddCityOpen] = useState(false);
  const [addAreaOpen, setAddAreaOpen] = useState<string | null>(null);
  const [newCityName, setNewCityName] = useState("");
  const [newAreaName, setNewAreaName] = useState("");

  const totalActive = citiesData.filter((c) => c.status === "ACTIVE").length;
  const totalAreas = citiesData.reduce((a, c) => a + (c._count?.areas || 0), 0);

  const handleAddCity = () => {
    if (!newCityName.trim()) return;
    const toastId = toast.loading("Adding city...");
    createCityMutation.mutate(
      { name: newCityName.trim(), status: "ACTIVE" },
      {
        onSuccess: () => {
          toast.success("City added successfully", { id: toastId });
          setNewCityName("");
          setAddCityOpen(false);
        },
        onError: (err: any) => {
          toast.error(err.response?.data?.message || "Failed to add city", { id: toastId });
        }
      }
    );
  };

  const handleAddArea = (cityId: string) => {
    if (!newAreaName.trim()) return;
    const toastId = toast.loading("Adding area...");
    createAreaMutation.mutate(
      { cityId, payload: { name: newAreaName.trim(), isActive: true } },
      {
        onSuccess: () => {
          toast.success("Area added successfully", { id: toastId });
          setNewAreaName("");
          setAddAreaOpen(null);
        },
        onError: (err: any) => {
          toast.error(err.response?.data?.message || "Failed to add area", { id: toastId });
        }
      }
    );
  };

  const toggleCityStatus = (cityId: string, currentStatus: string) => {
    const newStatus = currentStatus === "ACTIVE" ? "INACTIVE" : "ACTIVE";
    const toastId = toast.loading("Updating status...");
    updateCityMutation.mutate(
      { id: cityId, payload: { status: newStatus } },
      {
        onSuccess: () => toast.success("Status updated", { id: toastId }),
        onError: (err: any) => toast.error(err.response?.data?.message || "Failed to update status", { id: toastId })
      }
    );
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between animate-in-view">
        <div>
          <h1 className="text-2xl md:text-3xl font-bold tracking-tight">Cities & Areas</h1>
          <p className="text-muted-foreground mt-1">Manage platform geography — cities and their areas.</p>
        </div>
        <Button className="rounded-lg shadow-sm shadow-primary/20" onClick={() => setAddCityOpen(true)}>
          <Plus className="h-4 w-4 mr-1.5" /> Add City
        </Button>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 sm:grid-cols-3 gap-4 animate-in-view" style={{ animationDelay: "60ms" }}>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2.5 rounded-xl bg-[hsl(250,60%,52%)] text-white"><Building2 className="h-4 w-4" /></div>
            <div><p className="text-2xl font-bold tabular-nums">{citiesData.length}</p><p className="text-xs text-muted-foreground font-medium">Total Cities</p></div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2.5 rounded-xl bg-[hsl(170,60%,42%)] text-white"><MapPin className="h-4 w-4" /></div>
            <div><p className="text-2xl font-bold tabular-nums">{totalActive}</p><p className="text-xs text-muted-foreground font-medium">Active Cities</p></div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2.5 rounded-xl bg-[hsl(35,92%,52%)] text-white"><Map className="h-4 w-4" /></div>
            <div><p className="text-2xl font-bold tabular-nums">{totalAreas}</p><p className="text-xs text-muted-foreground font-medium">Total Areas</p></div>
          </CardContent>
        </Card>
      </div>

      {/* City List */}
      <div className="space-y-4 animate-in-view" style={{ animationDelay: "120ms" }}>
        {isCitiesLoading ? (
          <div className="flex justify-center p-12"><Loader2 className="animate-spin h-8 w-8 text-primary" /></div>
        ) : (
        <Accordion type="multiple" defaultValue={citiesData[0] ? [citiesData[0].id] : undefined}>
          {citiesData.map((city) => (
            <AccordionItem key={city.id} value={city.id} className="border rounded-xl mb-3 overflow-hidden shadow-sm bg-card">
              <AccordionTrigger className="px-5 py-4 hover:no-underline">
                <div className="flex items-center gap-3">
                  <span className="font-semibold text-base">{city.name}</span>
                  <Badge className={
                    city.status === "ACTIVE"
                      ? "bg-[hsl(170,50%,95%)] text-[hsl(170,60%,32%)] hover:bg-[hsl(170,50%,90%)]"
                      : "bg-[hsl(35,80%,95%)] text-[hsl(35,92%,40%)] hover:bg-[hsl(35,80%,90%)]"
                  }>
                    {city.status === "ACTIVE" ? "Active" : "Inactive"}
                  </Badge>
                  <span className="text-xs text-muted-foreground">{city._count?.areas || 0} areas</span>
                </div>
              </AccordionTrigger>
              <AccordionContent className="px-5 pb-4">
                <div className="flex items-center justify-between mb-4 mt-2">
                  <div className="flex items-center gap-2">
                    <Label className="text-xs text-muted-foreground">City Status</Label>
                    <Switch checked={city.status === "ACTIVE"} onCheckedChange={() => toggleCityStatus(city.id, city.status)} disabled={updateCityMutation.isPending} />
                  </div>
                  <Button size="sm" variant="outline" className="rounded-lg text-xs" onClick={() => { setAddAreaOpen(city.id); setNewAreaName(""); }}>
                    <Plus className="h-3 w-3 mr-1" /> Add Area
                  </Button>
                </div>
                <CityAreaList cityId={city.id} />
              </AccordionContent>
            </AccordionItem>
          ))}
        </Accordion>
        )}
      </div>

      {/* Add City Dialog */}
      <Dialog open={addCityOpen} onOpenChange={setAddCityOpen}>
        <DialogContent className="rounded-2xl">
          <DialogHeader><DialogTitle>Add New City</DialogTitle></DialogHeader>
          <div className="py-2">
            <Label className="text-xs text-muted-foreground">City Name</Label>
            <Input value={newCityName} onChange={(e) => setNewCityName(e.target.value)} placeholder="e.g. Rajkot" className="rounded-lg mt-1" />
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setAddCityOpen(false)} className="rounded-lg">Cancel</Button>
            <Button onClick={handleAddCity} className="rounded-lg" disabled={createCityMutation.isPending}>
              {createCityMutation.isPending && <Loader2 className="h-4 w-4 mr-1.5 animate-spin" />}
              Add City
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Add Area Dialog */}
      <Dialog open={!!addAreaOpen} onOpenChange={() => setAddAreaOpen(null)}>
        <DialogContent className="rounded-2xl">
          <DialogHeader><DialogTitle>Add Area to {citiesData.find((c) => c.id === addAreaOpen)?.name}</DialogTitle></DialogHeader>
          <div className="py-2">
            <Label className="text-xs text-muted-foreground">Area Name</Label>
            <Input value={newAreaName} onChange={(e) => setNewAreaName(e.target.value)} placeholder="e.g. Udhna" className="rounded-lg mt-1" />
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setAddAreaOpen(null)} className="rounded-lg">Cancel</Button>
            <Button onClick={() => addAreaOpen && handleAddArea(addAreaOpen)} className="rounded-lg" disabled={createAreaMutation.isPending}>
              {createAreaMutation.isPending && <Loader2 className="h-4 w-4 mr-1.5 animate-spin" />}
              Add Area
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}

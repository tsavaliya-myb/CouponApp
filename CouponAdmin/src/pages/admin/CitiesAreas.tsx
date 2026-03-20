import { useState } from "react";
import { mockCities, type City, type CityArea } from "@/data/mock-data";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from "@/components/ui/accordion";
import { MapPin, Plus, Building2, Map } from "lucide-react";

export default function CitiesAreasPage() {
  const [citiesData, setCitiesData] = useState<City[]>(mockCities);
  const [addCityOpen, setAddCityOpen] = useState(false);
  const [addAreaOpen, setAddAreaOpen] = useState<string | null>(null);
  const [newCityName, setNewCityName] = useState("");
  const [newAreaName, setNewAreaName] = useState("");

  const totalActive = citiesData.filter((c) => c.status === "active").length;
  const totalAreas = citiesData.reduce((a, c) => a + c.areas.length, 0);

  const handleAddCity = () => {
    if (!newCityName.trim()) return;
    setCitiesData([...citiesData, { id: `city${Date.now()}`, name: newCityName.trim(), status: "coming_soon", areas: [] }]);
    setNewCityName("");
    setAddCityOpen(false);
  };

  const handleAddArea = (cityId: string) => {
    if (!newAreaName.trim()) return;
    setCitiesData(citiesData.map((c) =>
      c.id === cityId ? { ...c, areas: [...c.areas, { id: `a${Date.now()}`, name: newAreaName.trim(), active: true }] } : c
    ));
    setNewAreaName("");
    setAddAreaOpen(null);
  };

  const toggleAreaActive = (cityId: string, areaId: string) => {
    setCitiesData(citiesData.map((c) =>
      c.id === cityId ? { ...c, areas: c.areas.map((a) => a.id === areaId ? { ...a, active: !a.active } : a) } : c
    ));
  };

  const toggleCityStatus = (cityId: string) => {
    setCitiesData(citiesData.map((c) =>
      c.id === cityId ? { ...c, status: c.status === "active" ? "coming_soon" : "active" } : c
    ));
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
        <Accordion type="multiple" defaultValue={[citiesData[0]?.id]}>
          {citiesData.map((city) => (
            <AccordionItem key={city.id} value={city.id} className="border rounded-xl mb-3 overflow-hidden shadow-sm bg-card">
              <AccordionTrigger className="px-5 py-4 hover:no-underline">
                <div className="flex items-center gap-3">
                  <span className="font-semibold text-base">{city.name}</span>
                  <Badge className={
                    city.status === "active"
                      ? "bg-[hsl(170,50%,95%)] text-[hsl(170,60%,32%)] hover:bg-[hsl(170,50%,90%)]"
                      : "bg-[hsl(35,80%,95%)] text-[hsl(35,92%,40%)] hover:bg-[hsl(35,80%,90%)]"
                  }>
                    {city.status === "active" ? "Active" : "Coming Soon"}
                  </Badge>
                  <span className="text-xs text-muted-foreground">{city.areas.length} areas</span>
                </div>
              </AccordionTrigger>
              <AccordionContent className="px-5 pb-4">
                <div className="flex items-center justify-between mb-3">
                  <div className="flex items-center gap-2">
                    <Label className="text-xs text-muted-foreground">City Status</Label>
                    <Switch checked={city.status === "active"} onCheckedChange={() => toggleCityStatus(city.id)} />
                  </div>
                  <Button size="sm" variant="outline" className="rounded-lg text-xs" onClick={() => { setAddAreaOpen(city.id); setNewAreaName(""); }}>
                    <Plus className="h-3 w-3 mr-1" /> Add Area
                  </Button>
                </div>
                <div className="grid grid-cols-2 sm:grid-cols-3 gap-2">
                  {city.areas.map((area) => (
                    <div key={area.id} className="flex items-center justify-between bg-muted/40 rounded-lg px-3 py-2">
                      <span className={`text-sm font-medium ${!area.active ? "text-muted-foreground line-through" : ""}`}>{area.name}</span>
                      <Switch checked={area.active} onCheckedChange={() => toggleAreaActive(city.id, area.id)} className="scale-75" />
                    </div>
                  ))}
                </div>
              </AccordionContent>
            </AccordionItem>
          ))}
        </Accordion>
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
            <Button onClick={handleAddCity} className="rounded-lg">Add City</Button>
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
            <Button onClick={() => addAreaOpen && handleAddArea(addAreaOpen)} className="rounded-lg">Add Area</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}

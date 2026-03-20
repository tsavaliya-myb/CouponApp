import { useState } from "react";
import { mockNotifications, cities, areasByCity, type Notification } from "@/data/mock-data";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Bell, Send, Plus, Users, MapPin, Clock } from "lucide-react";

export default function NotificationsPage() {
  const [composeOpen, setComposeOpen] = useState(false);
  const [audience, setAudience] = useState("all");
  const [city, setCity] = useState("");

  const totalSent = mockNotifications.filter((n) => n.status === "sent").length;
  const totalDelivered = mockNotifications.reduce((a, n) => a + n.deliveredCount, 0);

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between animate-in-view">
        <div>
          <h1 className="text-2xl md:text-3xl font-bold tracking-tight">Notifications</h1>
          <p className="text-muted-foreground mt-1">Send push notifications and view delivery history.</p>
        </div>
        <Button className="rounded-lg shadow-sm shadow-primary/20" onClick={() => setComposeOpen(true)}>
          <Plus className="h-4 w-4 mr-1.5" /> Compose
        </Button>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 sm:grid-cols-3 gap-4 animate-in-view" style={{ animationDelay: "60ms" }}>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2.5 rounded-xl bg-[hsl(250,60%,52%)] text-white"><Send className="h-4 w-4" /></div>
            <div><p className="text-2xl font-bold tabular-nums">{totalSent}</p><p className="text-xs text-muted-foreground font-medium">Sent</p></div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2.5 rounded-xl bg-[hsl(170,60%,42%)] text-white"><Users className="h-4 w-4" /></div>
            <div><p className="text-2xl font-bold tabular-nums">{totalDelivered}</p><p className="text-xs text-muted-foreground font-medium">Delivered</p></div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2.5 rounded-xl bg-[hsl(35,92%,52%)] text-white"><Clock className="h-4 w-4" /></div>
            <div><p className="text-2xl font-bold tabular-nums">{mockNotifications.filter((n) => n.status === "scheduled").length}</p><p className="text-xs text-muted-foreground font-medium">Scheduled</p></div>
          </CardContent>
        </Card>
      </div>

      {/* History Table */}
      <Card className="border-0 shadow-sm animate-in-view" style={{ animationDelay: "120ms" }}>
        <Table>
          <TableHeader>
            <TableRow className="bg-muted/30">
              <TableHead>Title</TableHead>
              <TableHead>Audience</TableHead>
              <TableHead className="text-right">Delivered</TableHead>
              <TableHead>Status</TableHead>
              <TableHead>Sent At</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {mockNotifications.map((n) => (
              <TableRow key={n.id}>
                <TableCell>
                  <div><p className="font-medium text-sm">{n.title}</p><p className="text-xs text-muted-foreground line-clamp-1">{n.message}</p></div>
                </TableCell>
                <TableCell>
                  <Badge variant="secondary" className="text-xs capitalize">
                    {n.audience === "all" ? "All Users" : n.audience === "city" ? n.city : n.audience === "expiring" ? "Expiring Soon" : n.audience}
                  </Badge>
                </TableCell>
                <TableCell className="text-right tabular-nums">{n.deliveredCount}</TableCell>
                <TableCell>
                  <Badge className={
                    n.status === "sent" ? "bg-[hsl(170,50%,95%)] text-[hsl(170,60%,32%)] hover:bg-[hsl(170,50%,90%)]" :
                    n.status === "scheduled" ? "bg-[hsl(35,80%,95%)] text-[hsl(35,92%,40%)] hover:bg-[hsl(35,80%,90%)]" :
                    "bg-muted text-muted-foreground"
                  }>
                    {n.status}
                  </Badge>
                </TableCell>
                <TableCell className="text-muted-foreground text-sm">{new Date(n.sentAt).toLocaleDateString("en-IN", { day: "numeric", month: "short", hour: "2-digit", minute: "2-digit" })}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </Card>

      {/* Compose Dialog */}
      <Dialog open={composeOpen} onOpenChange={setComposeOpen}>
        <DialogContent className="rounded-2xl sm:max-w-lg">
          <DialogHeader><DialogTitle>Compose Notification</DialogTitle></DialogHeader>
          <div className="space-y-4 py-2">
            <div>
              <Label className="text-xs text-muted-foreground">Title</Label>
              <Input placeholder="Notification title" className="rounded-lg mt-1" />
            </div>
            <div>
              <Label className="text-xs text-muted-foreground">Message</Label>
              <Textarea placeholder="Write your notification message..." className="rounded-lg mt-1" rows={3} />
            </div>
            <div className="grid sm:grid-cols-2 gap-4">
              <div>
                <Label className="text-xs text-muted-foreground">Audience</Label>
                <Select value={audience} onValueChange={setAudience}>
                  <SelectTrigger className="rounded-lg mt-1"><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="all">All Users</SelectItem>
                    <SelectItem value="city">Specific City</SelectItem>
                    <SelectItem value="area">Specific Area</SelectItem>
                    <SelectItem value="expiring">Expiring Subscriptions</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              {(audience === "city" || audience === "area") && (
                <div>
                  <Label className="text-xs text-muted-foreground">City</Label>
                  <Select value={city} onValueChange={setCity}>
                    <SelectTrigger className="rounded-lg mt-1"><SelectValue placeholder="Select city" /></SelectTrigger>
                    <SelectContent>
                      {cities.map((c) => <SelectItem key={c} value={c}>{c}</SelectItem>)}
                    </SelectContent>
                  </Select>
                </div>
              )}
              {audience === "area" && city && (
                <div>
                  <Label className="text-xs text-muted-foreground">Area</Label>
                  <Select>
                    <SelectTrigger className="rounded-lg mt-1"><SelectValue placeholder="Select area" /></SelectTrigger>
                    <SelectContent>
                      {(areasByCity[city] || []).map((a) => <SelectItem key={a} value={a}>{a}</SelectItem>)}
                    </SelectContent>
                  </Select>
                </div>
              )}
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setComposeOpen(false)} className="rounded-lg">Cancel</Button>
            <Button className="rounded-lg" onClick={() => setComposeOpen(false)}>
              <Send className="h-4 w-4 mr-1.5" /> Send Now
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}

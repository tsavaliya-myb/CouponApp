import { useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Bell, Send, Plus, Users, MapPin, Clock, Loader2, ChevronLeft, ChevronRight } from "lucide-react";

import { useNotificationHistory } from "@/hooks/api/useNotification";
import { useCities, useAreas } from "@/hooks/api/useLocation";

export default function NotificationsPage() {
  const [composeOpen, setComposeOpen] = useState(false);
  const [audience, setAudience] = useState("GLOBAL");
  const [cityId, setCityId] = useState("");
  const [page, setPage] = useState(1);

  const { data: historyResp, isLoading: isHistoryLoading } = useNotificationHistory({ page, limit: 10 });
  const { data: citiesResp } = useCities();
  const { data: areasResp } = useAreas(audience === "AREA" ? cityId : null);

  const notifications = historyResp?.data?.data || [];
  const meta = historyResp?.data?.meta;

  const liveCities = citiesResp?.data || [];
  const liveAreas = areasResp?.data || [];

  const totalSent = meta?.totalCount || 0;
  const totalDelivered = "-";

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
            <div><p className="text-2xl font-bold tabular-nums">0</p><p className="text-xs text-muted-foreground font-medium">Scheduled</p></div>
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
            {isHistoryLoading ? (
               <TableRow><TableCell colSpan={5} className="text-center py-10"><Loader2 className="animate-spin h-6 w-6 mx-auto text-muted-foreground" /></TableCell></TableRow>
            ) : notifications.length === 0 ? (
               <TableRow><TableCell colSpan={5} className="text-center py-10 text-muted-foreground">No notifications found.</TableCell></TableRow>
            ) : (
                notifications.map((n) => (
                  <TableRow key={n.id}>
                    <TableCell>
                      <div><p className="font-medium text-sm">{n.title}</p><p className="text-xs text-muted-foreground line-clamp-1">{n.body}</p></div>
                    </TableCell>
                    <TableCell>
                      <Badge variant="secondary" className="text-xs capitalize">
                        {n.targetType}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-right tabular-nums">-</TableCell>
                    <TableCell>
                      <Badge className="bg-[hsl(170,50%,95%)] text-[hsl(170,60%,32%)] hover:bg-[hsl(170,50%,90%)]">
                        Sent
                      </Badge>
                    </TableCell>
                    <TableCell className="text-muted-foreground text-sm">{new Date(n.sentAt).toLocaleDateString("en-IN", { day: "numeric", month: "short", hour: "2-digit", minute: "2-digit" })}</TableCell>
                  </TableRow>
                ))
            )}
          </TableBody>
        </Table>

        {/* Pagination */ }
        {meta && meta.totalCount > 10 && (
          <div className="flex items-center justify-between px-4 py-3 border-t">
            <p className="text-sm text-muted-foreground">Showing {((page - 1) * 10) + 1} to {Math.min(page * 10, meta.totalCount)} of {meta.totalCount}</p>
            <div className="flex gap-2">
              <Button variant="outline" size="sm" onClick={() => setPage(page - 1)} disabled={page <= 1}><ChevronLeft className="h-4 w-4" /></Button>
              <Button variant="outline" size="sm" onClick={() => setPage(page + 1)} disabled={page * 10 >= meta.totalCount}><ChevronRight className="h-4 w-4" /></Button>
            </div>
          </div>
        )}
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
                    <SelectItem value="GLOBAL">All Users</SelectItem>
                    <SelectItem value="CITY">Specific City</SelectItem>
                    <SelectItem value="AREA">Specific Area</SelectItem>
                    <SelectItem value="EXPIRING">Expiring Subscriptions</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              {(audience === "CITY" || audience === "AREA") && (
                <div>
                  <Label className="text-xs text-muted-foreground">City</Label>
                  <Select value={cityId} onValueChange={setCityId}>
                    <SelectTrigger className="rounded-lg mt-1"><SelectValue placeholder="Select city" /></SelectTrigger>
                    <SelectContent>
                      {liveCities.map((c) => <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>)}
                    </SelectContent>
                  </Select>
                </div>
              )}
              {audience === "AREA" && cityId && (
                <div>
                  <Label className="text-xs text-muted-foreground">Area</Label>
                  <Select>
                    <SelectTrigger className="rounded-lg mt-1"><SelectValue placeholder="Select area" /></SelectTrigger>
                    <SelectContent>
                      {liveAreas.map((a) => <SelectItem key={a.id} value={a.id}>{a.name}</SelectItem>)}
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

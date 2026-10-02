import { useState, useEffect } from "react";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from "@/components/ui/sheet";
import { Search, CheckCircle, XCircle, Pause, Eye, Users } from "lucide-react";
import { useInfluencers, useApproveInfluencer, useSuspendInfluencer, useRejectInfluencer } from "@/hooks/api/useInfluencers";
import { useCities } from "@/hooks/api/useLocation";
import { format } from "date-fns";
import { toast } from "sonner";

const statusStyles: Record<string, string> = {
  ACTIVE: "bg-[hsl(145,50%,95%)] text-[hsl(170,60%,35%)] border-0",
  PENDING: "bg-[hsl(35,80%,95%)] text-[hsl(35,70%,35%)] border-0",
  SUSPENDED: "bg-[hsl(340,50%,96%)] text-[hsl(340,65%,42%)] border-0",
  REJECTED: "bg-[hsl(0,72%,96%)] text-[hsl(0,72%,51%)] border-0",
};

export default function InfluencersPage() {
  const [search, setSearch] = useState("");
  const [debouncedSearch, setDebouncedSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");
  const [selectedInfluencer, setSelectedInfluencer] = useState<any>(null);

  const approveMutation = useApproveInfluencer();
  const suspendMutation = useSuspendInfluencer();
  const rejectMutation = useRejectInfluencer();

  useEffect(() => {
    const handler = setTimeout(() => setDebouncedSearch(search), 400);
    return () => clearTimeout(handler);
  }, [search]);

  const { data: influencersRes, isLoading } = useInfluencers({
    search: debouncedSearch || undefined,
    status: statusFilter !== "all" ? statusFilter : undefined,
    page: 1,
    limit: 50,
  });

  const influencers = influencersRes?.data || [];

  const handleAction = async (id: string, action: 'approve' | 'suspend' | 'reject') => {
    try {
      if (action === 'approve') {
        await approveMutation.mutateAsync(id);
        toast.success("Influencer approved successfully");
      } else if (action === 'suspend') {
        await suspendMutation.mutateAsync(id);
        toast.success("Influencer suspended");
      } else {
        await rejectMutation.mutateAsync(id);
        toast.success("Influencer rejected");
      }
      setSelectedInfluencer(null);
    } catch (e: any) {
      toast.error(e.response?.data?.error || `Failed to ${action} influencer`);
    }
  };

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold tracking-tight text-[hsl(220,40%,20%)]">Influencers</h1>
        <p className="text-muted-foreground">Review and manage influencer accounts.</p>
      </div>

      <div className="flex flex-col sm:flex-row gap-4 justify-between">
        <div className="relative w-full max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input
            placeholder="Search influencers..."
            className="pl-9"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          />
        </div>
        
        <Select value={statusFilter} onValueChange={setStatusFilter}>
          <SelectTrigger className="w-full sm:w-[180px]">
            <SelectValue placeholder="Status" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Statuses</SelectItem>
            <SelectItem value="PENDING">Pending</SelectItem>
            <SelectItem value="ACTIVE">Active</SelectItem>
            <SelectItem value="SUSPENDED">Suspended</SelectItem>
            <SelectItem value="REJECTED">Rejected</SelectItem>
          </SelectContent>
        </Select>
      </div>

      <div className="rounded-xl border bg-card overflow-hidden">
        <Table>
          <TableHeader className="bg-muted/50">
            <TableRow>
              <TableHead>Influencer</TableHead>
              <TableHead>Niche</TableHead>
              <TableHead>City</TableHead>
              <TableHead>Followers</TableHead>
              <TableHead>Services</TableHead>
              <TableHead>Status</TableHead>
              <TableHead className="text-right">Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {isLoading ? (
              <TableRow>
                <TableCell colSpan={7} className="text-center py-8 text-muted-foreground">
                  Loading...
                </TableCell>
              </TableRow>
            ) : influencers.length === 0 ? (
              <TableRow>
                <TableCell colSpan={7} className="text-center py-8 text-muted-foreground">
                  No influencers found
                </TableCell>
              </TableRow>
            ) : (
              influencers.map((influencer: any) => (
                <TableRow key={influencer.id}>
                  <TableCell>
                    <div className="font-medium text-[hsl(220,40%,20%)]">{influencer.displayName}</div>
                    <div className="text-sm text-muted-foreground">{influencer.phone}</div>
                  </TableCell>
                  <TableCell>{influencer.niche?.name || "-"}</TableCell>
                  <TableCell>{influencer.city?.name || "-"}</TableCell>
                  <TableCell>{influencer.totalFollowers.toLocaleString()}</TableCell>
                  <TableCell>{influencer._count?.services || 0}</TableCell>
                  <TableCell>
                    <Badge variant="outline" className={statusStyles[influencer.status] || statusStyles.ACTIVE}>
                      {influencer.status}
                    </Badge>
                  </TableCell>
                  <TableCell className="text-right">
                    <Button variant="ghost" size="icon" onClick={() => setSelectedInfluencer(influencer)}>
                      <Eye className="h-4 w-4" />
                    </Button>
                  </TableCell>
                </TableRow>
              ))
            )}
          </TableBody>
        </Table>
      </div>

      <Sheet open={!!selectedInfluencer} onOpenChange={(o) => !o && setSelectedInfluencer(null)}>
        <SheetContent className="sm:max-w-xl overflow-y-auto">
          <SheetHeader className="pb-6 border-b">
            <SheetTitle>Influencer Profile</SheetTitle>
            <SheetDescription>Review details before approving or rejecting</SheetDescription>
          </SheetHeader>
          
          {selectedInfluencer && (
            <div className="py-6 space-y-6">
              <div className="flex items-start justify-between">
                <div>
                  <h3 className="font-semibold text-lg">{selectedInfluencer.displayName}</h3>
                  <p className="text-sm text-muted-foreground">{selectedInfluencer.fullName}</p>
                </div>
                <Badge variant="outline" className={statusStyles[selectedInfluencer.status] || statusStyles.ACTIVE}>
                  {selectedInfluencer.status}
                </Badge>
              </div>

              <div className="grid grid-cols-2 gap-4 text-sm">
                <div>
                  <span className="text-muted-foreground">Phone</span>
                  <p className="font-medium">{selectedInfluencer.phone}</p>
                </div>
                <div>
                  <span className="text-muted-foreground">Email</span>
                  <p className="font-medium">{selectedInfluencer.email || "-"}</p>
                </div>
                <div>
                  <span className="text-muted-foreground">Niche</span>
                  <p className="font-medium">{selectedInfluencer.niche?.name || "-"}</p>
                </div>
                <div>
                  <span className="text-muted-foreground">Total Followers</span>
                  <p className="font-medium">{selectedInfluencer.totalFollowers.toLocaleString()}</p>
                </div>
                <div>
                  <span className="text-muted-foreground">City</span>
                  <p className="font-medium">{selectedInfluencer.city?.name || "-"}</p>
                </div>
                <div>
                  <span className="text-muted-foreground">Platforms</span>
                  <p className="font-medium">{selectedInfluencer.platforms?.join(", ") || "-"}</p>
                </div>
              </div>

              {selectedInfluencer.bio && (
                <div>
                  <span className="text-muted-foreground text-sm">Bio</span>
                  <p className="font-medium text-sm mt-1">{selectedInfluencer.bio}</p>
                </div>
              )}

              {Object.keys(selectedInfluencer.socialLinks || {}).length > 0 && (
                <div>
                  <span className="text-muted-foreground text-sm">Social Links</span>
                  <ul className="mt-1 space-y-1">
                    {Object.entries(selectedInfluencer.socialLinks).map(([platform, link]: any) => (
                      <li key={platform}>
                        <a href={link} target="_blank" rel="noopener noreferrer" className="text-blue-500 hover:underline text-sm flex items-center gap-2">
                          {platform}: {link}
                        </a>
                      </li>
                    ))}
                  </ul>
                </div>
              )}

              <div className="flex flex-wrap gap-2 pt-6 border-t">
                {selectedInfluencer.status === "PENDING" && (
                  <>
                    <Button 
                      className="bg-green-600 hover:bg-green-700 text-white" 
                      onClick={() => handleAction(selectedInfluencer.id, 'approve')}
                      disabled={approveMutation.isPending}
                    >
                      <CheckCircle className="mr-2 h-4 w-4" /> Approve
                    </Button>
                    <Button 
                      variant="destructive" 
                      onClick={() => handleAction(selectedInfluencer.id, 'reject')}
                      disabled={rejectMutation.isPending}
                    >
                      <XCircle className="mr-2 h-4 w-4" /> Reject
                    </Button>
                  </>
                )}
                {selectedInfluencer.status === "ACTIVE" && (
                  <Button 
                    variant="outline" 
                    className="text-red-600 border-red-200 hover:bg-red-50"
                    onClick={() => handleAction(selectedInfluencer.id, 'suspend')}
                    disabled={suspendMutation.isPending}
                  >
                    <Pause className="mr-2 h-4 w-4" /> Suspend Account
                  </Button>
                )}
                {selectedInfluencer.status === "SUSPENDED" && (
                  <Button 
                    variant="outline" 
                    className="text-green-600 border-green-200 hover:bg-green-50"
                    onClick={() => handleAction(selectedInfluencer.id, 'approve')}
                    disabled={approveMutation.isPending}
                  >
                    <CheckCircle className="mr-2 h-4 w-4" /> Reactivate Account
                  </Button>
                )}
              </div>
            </div>
          )}
        </SheetContent>
      </Sheet>
    </div>
  );
}

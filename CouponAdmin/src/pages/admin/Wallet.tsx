import { useState, useEffect } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Coins, Settings2, ArrowUpCircle, ArrowDownCircle, Gift, AlertCircle, Loader2 } from "lucide-react";
import { toast } from "sonner";

import { useWalletSettings, useUpdateWalletSettings, useBulkAwardCoins, useWalletOverview } from "@/hooks/api/useWallet";
import { useCities } from "@/hooks/api/useLocation";

export default function WalletPage() {
  const { data: walletData, isLoading: isWalletLoading } = useWalletSettings();
  const { data: overviewData, isLoading: isOverviewLoading } = useWalletOverview();
  const updateWalletMutation = useUpdateWalletSettings();
  const bulkAwardMutation = useBulkAwardCoins();
  const { data: citiesData, isLoading: isCitiesLoading } = useCities();
  
  const apiWalletSettings = walletData?.data;
  const overview = overviewData?.data;
  const apiCities = citiesData?.data || [];

  const [bulkOpen, setBulkOpen] = useState(false);
  const [bulkAmount, setBulkAmount] = useState("");
  const [bulkCityId, setBulkCityId] = useState("all");
  const [bulkNote, setBulkNote] = useState("");
  const [coinsPerSub, setCoinsPerSub] = useState("0");
  const [maxCoins, setMaxCoins] = useState("0");

  useEffect(() => {
    if (apiWalletSettings) {
      setCoinsPerSub(String(apiWalletSettings.coinsPerSubscription));
      setMaxCoins(String(apiWalletSettings.maxCoinsPerTransaction));
    }
  }, [apiWalletSettings]);

  const handleSave = () => {
    const toastId = toast.loading("Saving settings...");
    updateWalletMutation.mutate({
      coinsPerSubscription: Number(coinsPerSub),
      maxCoinsPerTransaction: Number(maxCoins),
    }, {
      onSuccess: () => toast.success("Settings saved successfully", { id: toastId }),
      onError: () => toast.error("Failed to save wallet settings", { id: toastId })
    });
  };

  const handleBulkAward = () => {
    if (!bulkAmount || Number(bulkAmount) <= 0) {
      toast.error("Please enter a valid amount");
      return;
    }
    const toastId = toast.loading("Awarding coins...");
    bulkAwardMutation.mutate({
      amount: Number(bulkAmount),
      cityId: bulkCityId === "all" ? undefined : bulkCityId,
      note: bulkNote || "Promotional award from administration"
    }, {
      onSuccess: (res) => {
        toast.success(`Successfully awarded ${res.data.totalCoins} coins to ${res.data.awardedCount} users!`, { id: toastId });
        setBulkOpen(false);
        setBulkAmount("");
        setBulkNote("");
        setBulkCityId("all");
      },
      onError: (err: any) => {
        toast.error(err.response?.data?.message || "Failed to bulk award coins", { id: toastId });
      }
    });
  };

  return (
    <div className="space-y-6">
      <div className="animate-in-view">
        <h1 className="text-2xl md:text-3xl font-bold tracking-tight">Wallet Management</h1>
        <p className="text-muted-foreground mt-1">Manage coin settings, transactions, and platform-wide coin operations.</p>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 animate-in-view" style={{ animationDelay: "60ms" }}>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2.5 rounded-xl bg-[hsl(170,60%,42%)] text-white"><ArrowUpCircle className="h-4 w-4" /></div>
            <div>
              {isOverviewLoading ? <Loader2 className="h-4 w-4 animate-spin mt-2 mb-1" /> : (
                <p className="text-2xl font-bold tabular-nums">{overview?.totalIssued || 0}</p>
              )}
              <p className="text-xs text-muted-foreground font-medium">Total Coins Awarded</p>
            </div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2.5 rounded-xl bg-[hsl(340,65%,52%)] text-white"><ArrowDownCircle className="h-4 w-4" /></div>
            <div>
              {isOverviewLoading ? <Loader2 className="h-4 w-4 animate-spin mt-2 mb-1" /> : (
                <p className="text-2xl font-bold tabular-nums">{overview?.totalUsed || 0}</p>
              )}
              <p className="text-xs text-muted-foreground font-medium">Total Coins Used</p>
            </div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2.5 rounded-xl bg-[hsl(35,92%,52%)] text-white"><AlertCircle className="h-4 w-4" /></div>
            <div>
              {isOverviewLoading ? <Loader2 className="h-4 w-4 animate-spin mt-2 mb-1" /> : (
                <p className="text-2xl font-bold tabular-nums">₹{overview?.outstandingLiability.toLocaleString("en-IN") || 0}</p>
              )}
              <p className="text-xs text-muted-foreground font-medium">Outstanding Liability</p>
            </div>
          </CardContent>
        </Card>
        <Card className="border-0 shadow-sm">
          <CardContent className="p-4 flex items-center gap-3">
            <div className="p-2.5 rounded-xl bg-[hsl(250,60%,52%)] text-white"><Settings2 className="h-4 w-4" /></div>
            <div>
              {isWalletLoading ? (
                 <Loader2 className="h-4 w-4 animate-spin text-muted-foreground mt-2 mb-1" />
              ) : (
                 <p className="text-2xl font-bold tabular-nums">{apiWalletSettings?.coinsPerSubscription || 0}</p>
              )}
              <p className="text-xs text-muted-foreground font-medium">Coins / Subscription</p>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Coin Settings Card */}
      <Card className="border-0 shadow-sm animate-in-view" style={{ animationDelay: "120ms" }}>
        <CardHeader className="pb-3 flex flex-row items-center justify-between space-y-0">
          <CardTitle className="text-sm font-semibold flex items-center gap-2">
            <Settings2 className="h-4 w-4" /> Coin Settings
          </CardTitle>
          {isWalletLoading && <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />}
        </CardHeader>
        <CardContent>
          <div className="grid sm:grid-cols-2 gap-4">
            <div>
              <Label className="text-xs text-muted-foreground">Coins per Subscription</Label>
              <Input type="number" value={coinsPerSub} onChange={(e) => setCoinsPerSub(e.target.value)} className="mt-1 rounded-lg" />
            </div>
            <div>
              <Label className="text-xs text-muted-foreground">Max Coins per Transaction</Label>
              <Input type="number" value={maxCoins} onChange={(e) => setMaxCoins(e.target.value)} className="mt-1 rounded-lg" />
            </div>
          </div>
          <div className="flex gap-2 mt-4">
            <Button className="rounded-lg" onClick={handleSave} disabled={updateWalletMutation.isPending}>
              {updateWalletMutation.isPending && <Loader2 className="h-4 w-4 mr-1.5 animate-spin" />}
              Save Settings
            </Button>
            <Button variant="outline" className="rounded-lg" onClick={() => setBulkOpen(true)}>
              <Gift className="h-4 w-4 mr-1.5" /> Bulk Award Coins
            </Button>
          </div>
        </CardContent>
      </Card>

      {/* Bulk Award Dialog */}
      <Dialog open={bulkOpen} onOpenChange={setBulkOpen}>
        <DialogContent className="rounded-2xl">
          <DialogHeader><DialogTitle>Bulk Award Coins</DialogTitle></DialogHeader>
          <div className="space-y-4 py-2">
            <div>
              <Label className="text-xs text-muted-foreground">Audience</Label>
              <Select value={bulkCityId} onValueChange={setBulkCityId} disabled={isCitiesLoading}>
                <SelectTrigger className="rounded-lg mt-1">
                  <SelectValue placeholder={isCitiesLoading ? "Loading cities..." : "Select Audience"} />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">All Users</SelectItem>
                  {apiCities.map(c => <SelectItem key={c.id} value={c.id}>{c.name} Users</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div>
              <Label className="text-xs text-muted-foreground">Coins per User</Label>
              <Input type="number" value={bulkAmount} onChange={(e) => setBulkAmount(e.target.value)} placeholder="e.g. 10" className="rounded-lg mt-1" />
            </div>
            <div>
              <Label className="text-xs text-muted-foreground">Note (Optional)</Label>
              <Input value={bulkNote} onChange={(e) => setBulkNote(e.target.value)} placeholder="e.g. Festival Bonus" className="rounded-lg mt-1" />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setBulkOpen(false)} className="rounded-lg">Cancel</Button>
            <Button className="rounded-lg" onClick={handleBulkAward} disabled={bulkAwardMutation.isPending}>
              {bulkAwardMutation.isPending && <Loader2 className="h-4 w-4 mr-1.5 animate-spin" />}
              Award to Selection
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}

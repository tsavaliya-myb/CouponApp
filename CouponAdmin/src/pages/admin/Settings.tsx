import { useState } from "react";
import { appSettings } from "@/data/mock-data";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Separator } from "@/components/ui/separator";
import { Settings as SettingsIcon, IndianRupee, Calendar, Coins, MessageSquare, Save } from "lucide-react";
import { toast } from "sonner";

export default function SettingsPage() {
  const [price, setPrice] = useState(String(appSettings.subscriptionPrice));
  const [validity, setValidity] = useState(String(appSettings.bookValidityDays));
  const [coinsPerSub, setCoinsPerSub] = useState(String(appSettings.coinsPerSubscription));
  const [maxCoins, setMaxCoins] = useState(String(appSettings.maxCoinsPerTransaction));
  const [templates, setTemplates] = useState(appSettings.notificationTemplates);

  const handleSave = () => {
    toast.success("Settings saved successfully");
  };

  return (
    <div className="space-y-6 max-w-3xl">
      <div className="animate-in-view">
        <h1 className="text-2xl md:text-3xl font-bold tracking-tight">App Settings</h1>
        <p className="text-muted-foreground mt-1">Configure subscription pricing, coin rules, and notification templates.</p>
      </div>

      {/* Subscription Settings */}
      <Card className="border-0 shadow-sm animate-in-view" style={{ animationDelay: "60ms" }}>
        <CardHeader className="pb-3">
          <CardTitle className="text-sm font-semibold flex items-center gap-2"><IndianRupee className="h-4 w-4" /> Subscription</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid sm:grid-cols-2 gap-4">
            <div>
              <Label className="text-xs text-muted-foreground">Subscription Price (₹)</Label>
              <Input type="number" value={price} onChange={(e) => setPrice(e.target.value)} className="rounded-lg mt-1" />
            </div>
            <div>
              <Label className="text-xs text-muted-foreground">Book Validity (days)</Label>
              <Input type="number" value={validity} onChange={(e) => setValidity(e.target.value)} className="rounded-lg mt-1" />
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Coin Settings */}
      <Card className="border-0 shadow-sm animate-in-view" style={{ animationDelay: "120ms" }}>
        <CardHeader className="pb-3">
          <CardTitle className="text-sm font-semibold flex items-center gap-2"><Coins className="h-4 w-4" /> Coin Rules</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid sm:grid-cols-2 gap-4">
            <div>
              <Label className="text-xs text-muted-foreground">Coins per Subscription Purchase</Label>
              <Input type="number" value={coinsPerSub} onChange={(e) => setCoinsPerSub(e.target.value)} className="rounded-lg mt-1" />
            </div>
            <div>
              <Label className="text-xs text-muted-foreground">Max Coins per Transaction</Label>
              <Input type="number" value={maxCoins} onChange={(e) => setMaxCoins(e.target.value)} className="rounded-lg mt-1" />
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Notification Templates */}
      <Card className="border-0 shadow-sm animate-in-view" style={{ animationDelay: "180ms" }}>
        <CardHeader className="pb-3">
          <CardTitle className="text-sm font-semibold flex items-center gap-2"><MessageSquare className="h-4 w-4" /> Notification Templates</CardTitle>
          <p className="text-xs text-muted-foreground">Use {"{days}"}, {"{coins}"} as placeholders.</p>
        </CardHeader>
        <CardContent className="space-y-4">
          <div>
            <Label className="text-xs text-muted-foreground">Expiry Reminder</Label>
            <Textarea value={templates.expiryReminder} onChange={(e) => setTemplates({ ...templates, expiryReminder: e.target.value })} className="rounded-lg mt-1" rows={2} />
          </div>
          <div>
            <Label className="text-xs text-muted-foreground">Welcome Message</Label>
            <Textarea value={templates.welcome} onChange={(e) => setTemplates({ ...templates, welcome: e.target.value })} className="rounded-lg mt-1" rows={2} />
          </div>
          <div>
            <Label className="text-xs text-muted-foreground">Renewal Success</Label>
            <Textarea value={templates.renewalSuccess} onChange={(e) => setTemplates({ ...templates, renewalSuccess: e.target.value })} className="rounded-lg mt-1" rows={2} />
          </div>
          <div>
            <Label className="text-xs text-muted-foreground">Coin Credit</Label>
            <Textarea value={templates.coinCredit} onChange={(e) => setTemplates({ ...templates, coinCredit: e.target.value })} className="rounded-lg mt-1" rows={2} />
          </div>
        </CardContent>
      </Card>

      {/* Save */}
      <div className="animate-in-view" style={{ animationDelay: "240ms" }}>
        <Button onClick={handleSave} className="rounded-lg shadow-sm shadow-primary/20">
          <Save className="h-4 w-4 mr-1.5" /> Save All Settings
        </Button>
      </div>
    </div>
  );
}

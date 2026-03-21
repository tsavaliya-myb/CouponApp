import { useState, useEffect } from "react";
import { appSettings } from "@/data/mock-data";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Separator } from "@/components/ui/separator";
import { Settings as SettingsIcon, IndianRupee, Calendar, Coins, MessageSquare, Save } from "lucide-react";
import { toast } from "sonner";
import { Loader2 } from "lucide-react";

import { useSystemSettings, useUpdateSystemSettings } from "@/hooks/api/useSettings";

export default function SettingsPage() {
  const { data: settingsResp, isLoading } = useSystemSettings();
  const updateSettingsMutation = useUpdateSystemSettings();
  const apiSettings = settingsResp?.data;

  const [formData, setFormData] = useState<Record<string, string>>({
    subscription_price: "",
    book_validity_days: "",
    coins_per_subscription: "",
    max_coins_per_transaction: "",
    expiry_reminder_7d_title: "",
    expiry_reminder_7d_body: "",
    expiry_reminder_2d_title: "",
    expiry_reminder_2d_body: "",
    daily_motivation_title: "",
    daily_motivation_body: "",
  });

  useEffect(() => {
    if (apiSettings) {
      setFormData(apiSettings as Record<string, string>);
    }
  }, [apiSettings]);

  const handleChange = (key: string, value: string) => {
    setFormData((prev) => ({ ...prev, [key]: value }));
  };

  const handleSave = () => {
    const toastId = toast.loading("Saving settings...");
    
    updateSettingsMutation.mutate(formData, {
      onSuccess: () => {
        toast.success("Settings saved successfully", { id: toastId });
      },
      onError: (err: any) => {
        toast.error(err.response?.data?.message || "Failed to save settings", { id: toastId });
      }
    });
  };

  return (
    <div className="space-y-6 max-w-3xl">
      <div className="animate-in-view">
        <h1 className="text-2xl md:text-3xl font-bold tracking-tight">App Settings</h1>
        <p className="text-muted-foreground mt-1">Configure subscription pricing, coin rules, and notification templates.</p>
      </div>

      {/* Subscription Settings */}
      <Card className="border-0 shadow-sm animate-in-view" style={{ animationDelay: "60ms" }}>
        <CardHeader className="pb-3 flex flex-row items-center justify-between space-y-0">
          <CardTitle className="text-sm font-semibold flex items-center gap-2"><IndianRupee className="h-4 w-4" /> Subscription</CardTitle>
          {isLoading && <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />}
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid sm:grid-cols-2 gap-4">
            <div>
              <Label className="text-xs text-muted-foreground">Subscription Price (₹)</Label>
              <Input type="number" value={formData.subscription_price} onChange={(e) => handleChange("subscription_price", e.target.value)} className="rounded-lg mt-1" />
            </div>
            <div>
              <Label className="text-xs text-muted-foreground">Book Validity (days)</Label>
              <Input type="number" value={formData.book_validity_days} onChange={(e) => handleChange("book_validity_days", e.target.value)} className="rounded-lg mt-1" />
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Coin Settings */}
      <Card className="border-0 shadow-sm animate-in-view" style={{ animationDelay: "120ms" }}>
        <CardHeader className="pb-3 flex flex-row items-center justify-between space-y-0">
          <CardTitle className="text-sm font-semibold flex items-center gap-2">
            <Coins className="h-4 w-4" /> Coin Rules (Wallet)
          </CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid sm:grid-cols-2 gap-4">
            <div>
              <Label className="text-xs text-muted-foreground">Coins per Subscription Purchase</Label>
              <Input type="number" value={formData.coins_per_subscription} onChange={(e) => handleChange("coins_per_subscription", e.target.value)} className="rounded-lg mt-1" />
            </div>
            <div>
              <Label className="text-xs text-muted-foreground">Max Coins per Transaction</Label>
              <Input type="number" value={formData.max_coins_per_transaction} onChange={(e) => handleChange("max_coins_per_transaction", e.target.value)} className="rounded-lg mt-1" />
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
        <CardContent className="space-y-6">
          <div className="space-y-3">
            <div className="flex items-center gap-2"><div className="h-2 w-2 rounded-full bg-[hsl(35,92%,52%)]"></div><Label className="font-semibold text-sm">7-Day Expiry Reminder</Label></div>
            <Input value={formData.expiry_reminder_7d_title} onChange={(e) => handleChange("expiry_reminder_7d_title", e.target.value)} className="rounded-lg" placeholder="Title" />
            <Textarea value={formData.expiry_reminder_7d_body} onChange={(e) => handleChange("expiry_reminder_7d_body", e.target.value)} className="rounded-lg" rows={2} placeholder="Message body..." />
          </div>
          <Separator />
          <div className="space-y-3">
            <div className="flex items-center gap-2"><div className="h-2 w-2 rounded-full bg-[hsl(0,84%,60%)]"></div><Label className="font-semibold text-sm">2-Day Expiry Reminder</Label></div>
            <Input value={formData.expiry_reminder_2d_title} onChange={(e) => handleChange("expiry_reminder_2d_title", e.target.value)} className="rounded-lg" placeholder="Title" />
            <Textarea value={formData.expiry_reminder_2d_body} onChange={(e) => handleChange("expiry_reminder_2d_body", e.target.value)} className="rounded-lg" rows={2} placeholder="Message body..." />
          </div>
          <Separator />
          <div className="space-y-3">
            <div className="flex items-center gap-2"><div className="h-2 w-2 rounded-full bg-[hsl(250,60%,52%)]"></div><Label className="font-semibold text-sm">Daily Motivation</Label></div>
            <Input value={formData.daily_motivation_title} onChange={(e) => handleChange("daily_motivation_title", e.target.value)} className="rounded-lg" placeholder="Title" />
            <Textarea value={formData.daily_motivation_body} onChange={(e) => handleChange("daily_motivation_body", e.target.value)} className="rounded-lg" rows={2} placeholder="Message body..." />
          </div>
        </CardContent>
      </Card>

      {/* Save */}
      <div className="animate-in-view" style={{ animationDelay: "240ms" }}>
        <Button onClick={handleSave} disabled={updateSettingsMutation.isPending} className="rounded-lg shadow-sm shadow-primary/20">
          {updateSettingsMutation.isPending ? <Loader2 className="h-4 w-4 mr-1.5 animate-spin" /> : <Save className="h-4 w-4 mr-1.5" />} 
          Save All Settings
        </Button>
      </div>
    </div>
  );
}

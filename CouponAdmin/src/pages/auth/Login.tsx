import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useLogin } from "@/hooks/api/useAuth";
import { useAuthContext } from "@/contexts/AuthContext";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardDescription, CardHeader, CardTitle, CardFooter } from "@/components/ui/card";
import { toast } from "sonner";
import { Loader2, TicketPercent } from "lucide-react";

export default function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const navigate = useNavigate();
  const { login } = useAuthContext();
  const loginMutation = useLogin();

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    if (!email || !password) {
      toast.error("Please enter email and password");
      return;
    }

    loginMutation.mutate(
      [email, password],
      {
        onSuccess: (data) => {
          if (data.success) {
            login(data.data.accessToken, data.data.refreshToken, data.data.admin);
            toast.success("Welcome back!");
            navigate("/admin");
          } else {
            toast.error("Login failed. Please check your credentials.");
          }
        },
        onError: (error: any) => {
          const msg = error.response?.data?.message || "An error occurred during login";
          toast.error(msg);
        },
      }
    );
  };

  return (
    <div className="min-h-screen grid lg:grid-cols-2 bg-background">
      {/* Left Panel */}
      <div className="hidden lg:flex flex-col justify-center items-center bg-primary text-primary-foreground p-12 relative overflow-hidden">
        <div className="absolute top-0 left-0 w-full h-full opacity-10 pointer-events-none">
          {/* Subtle background decoration */}
          <div className="absolute top-[-10%] left-[-10%] w-[50%] h-[50%] rounded-full bg-white blur-3xl" />
          <div className="absolute bottom-[-10%] right-[-10%] w-[50%] h-[50%] rounded-full bg-white blur-3xl" />
        </div>

        <div className="max-w-md space-y-6 text-center z-10">
          <div className="inline-flex items-center justify-center p-5 bg-primary-foreground/15 rounded-[2rem] mb-4 shadow-2xl backdrop-blur-sm border border-primary-foreground/20">
            <TicketPercent className="w-16 h-16 text-primary-foreground" />
          </div>
          <h1 className="text-4xl font-extrabold tracking-tight">Coupon Admin</h1>
          <p className="text-lg opacity-90 leading-relaxed font-medium">
            Manage your network of sellers, control active campaigns, and monitor platform analytics from one powerful dashboard.
          </p>
        </div>
      </div>

      {/* Right Login Panel */}
      <div className="flex items-center justify-center p-6 md:p-12">
        <Card className="w-full max-w-sm border-0 shadow-none bg-transparent lg:shadow-2xl lg:border lg:bg-card lg:max-w-md xl:p-4 transition-all duration-300">
          <CardHeader className="space-y-3 text-center lg:text-left">
            <div className="lg:hidden flex justify-center mb-6">
              <div className="p-4 bg-primary/10 rounded-2xl text-primary relative overflow-hidden">
                <div className="absolute inset-0 bg-gradient-to-tr from-primary/20 to-transparent opacity-50" />
                <TicketPercent className="w-10 h-10 relative z-10" />
              </div>
            </div>
            <CardTitle className="text-3xl font-bold tracking-tight">Sign In</CardTitle>
            <CardDescription className="text-base text-muted-foreground">
              Enter your credentials to access the platform.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleLogin} className="space-y-5 mt-2">
              <div className="space-y-2.5">
                <Label htmlFor="email">Email Address</Label>
                <Input
                  id="email"
                  type="email"
                  placeholder="admin@couponapp.in"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  disabled={loginMutation.isPending}
                  className="bg-muted/50 focus-visible:bg-transparent h-11 transition-all focus-visible:ring-primary/50"
                  required
                />
              </div>
              <div className="space-y-2.5">
                <div className="flex items-center justify-between">
                  <Label htmlFor="password">Password</Label>
                  <a href="#" className="text-sm font-semibold text-primary/80 hover:text-primary transition-colors">Forgot Password?</a>
                </div>
                <Input
                  id="password"
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  disabled={loginMutation.isPending}
                  className="bg-muted/50 focus-visible:bg-transparent h-11 transition-all focus-visible:ring-primary/50"
                  required
                />
              </div>
              <Button
                type="submit"
                className="w-full h-11 text-base font-semibold shadow-xl shadow-primary/25 hover:shadow-primary/40 transition-all duration-300 active:scale-[0.98] mt-4"
                disabled={loginMutation.isPending}
              >
                {loginMutation.isPending ? (
                  <>
                    <Loader2 className="mr-2 h-5 w-5 animate-spin" />
                    Authenticating...
                  </>
                ) : (
                  "Login"
                )}
              </Button>
            </form>
          </CardContent>
          <CardFooter className="flex justify-center border-t border-border/50 pt-6 mt-4">
            <p className="text-xs font-medium text-muted-foreground/60 text-center">
              Secure admin portal. Unauthorized access is strictly prohibited.
            </p>
          </CardFooter>
        </Card>
      </div>
    </div>
  );
}

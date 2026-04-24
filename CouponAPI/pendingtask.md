Cloudflare Free Setup (Step by Step)
Prerequisites
You need a custom domain (e.g. api.couponapp.in). Cloudflare doesn't work with Render's .onrender.com subdomain.

Steps
1. Create free Cloudflare account → cloudflare.com → Sign up free

2. Add your domain → Dashboard → "Add a Site" → enter couponapp.in → select Free plan

3. Cloudflare gives you 2 nameservers, e.g.:

alice.ns.cloudflare.com
bob.ns.cloudflare.com
→ Go to your domain registrar (GoDaddy/Namecheap etc.) → replace existing nameservers with these two

4. Add DNS record in Cloudflare

Type	Name	Value	Proxy
CNAME	api	couponapp-r1vv.onrender.com	✅ Proxied (orange cloud)
This makes api.couponapp.in → Cloudflare → Render

5. Cache /media/* — Create a Cache Rule → Cloudflare Dashboard → Your Domain → Rules → Cache Rules → Create rule:

When: URL path starts with /media/
Cache: Eligible for cache ✅
Edge TTL: 1 day
6. Update your .env and Flutter app

env
API_BASE_URL=https://api.couponapp.in
dart
// app_config.dart
baseUrl: 'https://api.couponapp.in/api/v1',
Result
User requests /media/logos/file.jpeg
→ Cloudflare edge (cache HIT) → instant, 0 server load
→ Cloudflare edge (cache MISS, first time) → hits Render → caches it
Your 4 vCPU server only ever fetches each image once from S3. After that, Cloudflare serves it globally from 300+ edge locations.
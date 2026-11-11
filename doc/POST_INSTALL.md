## After install

1. Open the landing at `https://DOMAIN/PATH/` and the OS at `https://DOMAIN/PATH/os/`.
2. Log into the PHP OS with the admin email/password you set at install.
3. In PHP admin **Besucher** (`/admin/analytics`) scan the **2FA QR** (or copy the secret) into your authenticator app. Then open `https://DASHBOARD_DOMAIN/` — username = dashboard admin from install, password = PHP admin password, plus TOTP. After that, click **2FA eingerichtet — ausblenden** (and optionally delete `dashboard/data/admin-totp.txt` on the server).

   If the dashboard page stays empty/unreachable, on the server check:

   ```bash
   sudo yunohost app setting wndrs dashboard_domain
   sudo systemctl status wndrs --no-pager
   sudo curl -sS -o /dev/null -w '%{http_code}\n' http://127.0.0.1:$(sudo yunohost app setting wndrs port)/
   sudo nginx -t && sudo systemctl reload nginx
   sudo yunohost user permission update wndrs.dashboard -a visitors
   ```
4. In PHP Admin → Besucher, confirm `analytics.python_url` points at the dashboard URL.
5. In the Python dashboard, add a site with export endpoint `https://DOMAIN/PATH/os/a/x.php` and the collector secrets from `www/os/data/analytics/config.php`.
6. Optional: place `GeoLite2-Country.mmdb` (or DB-IP Country Lite) under `www/os/data/analytics/geo/` and enable geo in Admin.

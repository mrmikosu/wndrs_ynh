## After install

1. Open the landing at `https://DOMAIN/PATH/` and the OS at `https://DOMAIN/PATH/os/`.
2. Log into the PHP OS with the admin email/password you set at install.
3. Open the Python dashboard at `https://DASHBOARD_DOMAIN/`. The domain must exist in Yunohost **and** have a working DNS A/AAAA record (and ideally a Let's Encrypt cert). Use the dashboard admin username and the **same password** as the PHP admin. Import the TOTP secret from `dashboard/data/admin-totp.txt` on the server, then **delete that file**.

   If the page stays empty/unreachable, on the server check:

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

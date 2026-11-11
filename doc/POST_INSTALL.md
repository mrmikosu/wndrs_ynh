## After install

1. Open the landing at `https://DOMAIN/PATH/` and the OS at `https://DOMAIN/PATH/os/`.
2. Log into the PHP OS with the admin email/password you set at install.
3. Open the Python dashboard at `https://DASHBOARD_DOMAIN/`. Use the dashboard admin username and the **same password** as the PHP admin. Import the TOTP secret from `dashboard/data/admin-totp.txt` on the server, then **delete that file**.
4. In PHP Admin → Besucher, confirm `analytics.python_url` points at the dashboard URL.
5. In the Python dashboard, add a site with export endpoint `https://DOMAIN/PATH/os/a/x.php` and the collector secrets from `www/os/data/analytics/config.php`.
6. Optional: place `GeoLite2-Country.mmdb` (or DB-IP Country Lite) under `www/os/data/analytics/geo/` and enable geo in Admin.

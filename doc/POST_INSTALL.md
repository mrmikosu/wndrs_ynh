## After install

1. Open the landing at `https://DOMAIN/PATH/` and the OS at `https://DOMAIN/PATH/os/`.
2. Log into the PHP OS with the admin email/password you set at install.
3. In PHP admin **Besucher** (`/admin/analytics`) scan the **2FA QR** (or copy the secret) into your authenticator app. Then open `https://DASHBOARD_DOMAIN/` — username = dashboard admin from install, password = PHP admin password, plus TOTP. After that, click **2FA eingerichtet — ausblenden** (and optionally delete `dashboard/data/admin-totp.txt` on the server).
4. The Python dashboard site is **pre-seeded** with the collector secrets and export URL `https://DOMAIN/PATH/os/a/x.php`. Open the dashboard, confirm the site is listed, and click **Jetzt abrufen** once.
5. Optional GeoIP: place `GeoLite2-Country.mmdb` (or DB-IP Country Lite saved under that name) in `www/os/data/analytics/geo/`, then enable Geo in PHP Admin → Besucher. Example on the host:

   ```bash
   GEO=/var/www/wndrs/www/os/data/analytics/geo
   YM=$(date -u +%Y-%m)
   mkdir -p "$GEO"
   curl -fsSL "https://download.db-ip.com/free/dbip-country-lite-${YM}.mmdb.gz" | gunzip > "$GEO/GeoLite2-Country.mmdb"
   chown -R wndrs:www-data "$GEO"
   ```

### Notes

- Landing `data-k` is synced to `www/os/data/analytics/config.php` on install and upgrade — do not hand-edit keys in HTML.
- If you rotate secrets in the Python UI (**Secret erneuern**), copy the new PHP snippet into `config.php` and re-run an upgrade sync, or update landing `data-k` to match.
- Dashboard domain stays public (`visitors`, `auth_header=false`) so Yunohost SSO does not sit in front of the Python login.

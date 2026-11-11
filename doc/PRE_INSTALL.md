## Before you install

- Register **two domains** in Yunohost (Domains → Add): the public site domain **and** a dedicated dashboard subdomain (e.g. `stats.example.com`) with DNS A/AAAA pointing at this server.
- Do **not** open the site root or `/site` for the Python UI — after install the dashboard URL is exactly `https://DASHBOARD_DOMAIN/` (see app setting `dashboard_domain`).
- This app is meant for a **fresh install**. Migrating from an existing Yunohost `my_webapp` is manual — see ADMIN.md after install.
- Build or download `sources/app.tar.gz` into this package before ZIP install (`yunohost/build-sources.sh` in the monorepo).
- GeoIP country DB is **not** bundled (license). Drop an MMDB into `www/os/data/analytics/geo/` after install if needed.

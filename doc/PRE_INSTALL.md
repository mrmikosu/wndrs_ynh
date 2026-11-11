## Before you install

- Register **two domains** (or one domain + one subdomain): the public site domain and a dashboard domain (e.g. `stats.example.com`).
- This app is meant for a **fresh install**. Migrating from an existing Yunohost `my_webapp` is manual — see ADMIN.md after install.
- Build or download `sources/app.tar.gz` into this package before ZIP install (`yunohost/build-sources.sh` in the monorepo).
- GeoIP country DB is **not** bundled (license). Drop an MMDB into `www/os/data/analytics/geo/` after install if needed.

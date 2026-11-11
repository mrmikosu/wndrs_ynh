# wndrs_ynh

Yunohost app for **WNDRS KLLKTV**: public landing, PHP member OS, visitor analytics collector, and Python dashboard.

## Install

```bash
sudo yunohost app install https://github.com/mrmikosu/wndrs_ynh
```

Or in Webadmin: **Applications → Install → Custom** and paste that URL.

You will be asked for:

- Public domain + path (default `/site`)
- Dashboard domain (HTTPS)
- PHP admin email + password
- Dashboard admin username

After install, read the TOTP secret from `dashboard/data/admin-totp.txt` on the server, add it to your authenticator, then delete the file.

## Layout

| URL | Content |
|-----|---------|
| `https://DOMAIN/site/` | Landing |
| `https://DOMAIN/site/os/` | PHP OS + collector (`/a/`) |
| `https://DASHBOARD_DOMAIN/` | Python analytics dashboard |

## Source

Built from the monorepo [mrmikosu/wndrser](https://github.com/mrmikosu/wndrser) (`yunohost/` + `besucher-analyse/`). Rebuild payload with `./yunohost/build-sources.sh` there, then sync this package repo.

# Yunohost app: `wndrs_ynh`

Custom Yunohost application packaging the WNDRS stack:

- Vite landing under `$path` (default `/site`)
- PHP OS under `$path/os`
- Analytics collector under `$path/os/a`
- Python dashboard on a dedicated domain (systemd + reverse proxy)

## Build the installable ZIP

From the monorepo root (needs Node for the landing build):

```bash
./yunohost/build-ynh-zip.sh
```

Artifact: `yunohost/dist/wndrs_ynh.zip` (includes `sources/app.tar.gz`).

## Install

**Webadmin:** Applications → Install → Custom / from zip → select `wndrs_ynh.zip`.

**CLI:**

```bash
sudo yunohost app install ./yunohost/dist/wndrs_ynh.zip
```

You will be asked for:

- Public domain + path (default `/site`)
- Dashboard domain (e.g. `stats.your.domain`)
- PHP admin email + password
- Dashboard admin username (password = PHP admin password; TOTP written to `dashboard/data/admin-totp.txt`)

## Git install (recommended)

Dedicated package repo (Yunohost package at root, includes `sources/app.tar.gz`):

```bash
sudo yunohost app install https://github.com/mrmikosu/wndrs_ynh
```

Repo: https://github.com/mrmikosu/wndrs_ynh

To refresh that repo after monorepo changes: rebuild with `./yunohost/build-sources.sh`, then copy `yunohost/wndrs_ynh/` (including `sources/`) into the package repo and push.

## After install

See `wndrs_ynh/doc/POST_INSTALL.md` and `ADMIN.md` (migration from `my_webapp`).

# Admin notes

## Paths

| URL | Content |
|-----|---------|
| `/PATH/` | Vite landing |
| `/PATH/os/` | PHP Kollektiv OS |
| `/PATH/os/a/` | Analytics collector |
| dashboard domain | Python Starlette dashboard |

## Migration from `my_webapp__3`

1. Backup old `www/` (landing) and `www/os/data/` + `www/os/config.php`.
2. Install this app on a staging path/domain.
3. Stop traffic; copy `config.php` and `data/` into the new `$install_dir/www/os/` (keep new analytics keys or merge carefully).
4. Align `base_path`, landing tracker script, and collector `origins`.
5. Point DNS; remove the old my_webapp instance when stable.

## Upgrades

`yunohost app upgrade wndrs` replaces code but keeps `www/os/data/`, `www/os/config.php`, and `dashboard/data/`.

On every upgrade the package also:
- re-applies dashboard `visitors` + `auth_header=false` and regenerates SSOwat
- rewrites `DASH_PUBLIC_HOST` / nginx `X-Forwarded-Host`
- syncs landing `data-k` from `www/os/data/analytics/config.php`
- idempotently runs `manage.py ensure-site` so export secrets stay aligned

## Cron

Point a system cron or Yunohost job at:

`php $install_dir/www/os/cron/worker.php`

or `GET https://DOMAIN/PATH/os/?r=/cron&token=CRON_TOKEN` if exposed by the OS router.

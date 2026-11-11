#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

# $php_version is set by the apt resource when phpX.Y-fpm is listed in manifest.toml.
phpversion="${php_version:-${phpversion:-8.2}}"
php_version="${php_version:-$phpversion}"

# Production Vite build ships with base "/site/". Rewrite baked-in base in assets
# when the Yunohost path is not /site (e.g. live root install → "/").
wndrs_rewrite_vite_base() {
  local install_dir="${1:-$install_dir}"
  local path_prefix="${2:-${path:-/}}"
  local new_base assets
  path_prefix="${path_prefix%/}"
  if [[ -z "$path_prefix" || "$path_prefix" == "/" ]]; then
    new_base="/"
  else
    new_base="${path_prefix}/"
  fi
  [[ "$new_base" == "/site/" ]] && return 0
  assets="$install_dir/www/assets"
  [[ -d "$assets" ]] || return 0
  find "$assets" -type f \( -name '*.js' -o -name '*.css' \) -print0 2>/dev/null \
    | while IFS= read -r -d '' f; do
        sed -i "s#\"/site/\"#\"${new_base}\"#g" "$f" || true
        sed -i "s#'/site/'#'${new_base}'#g" "$f" || true
      done
}

# Point canonical / OG / sitemap / llms absolute URLs at the install domain.
# Source ships https://kllktv.wndrs.de (and legacy https://wndrs.de) as defaults.
wndrs_sync_seo_host() {
  local install_dir="${1:-$install_dir}"
  local domain_name="${2:-$domain}"
  local www="$install_dir/www"
  local origin="https://${domain_name}"
  local f

  [[ -n "$domain_name" && -d "$www" ]] || return 0

  for f in "$www/index.html" "$www/robots.txt" "$www/sitemap.xml" "$www/llms.txt" "$www/llms-full.txt"; do
    [[ -f "$f" ]] || continue
    # Longer host first so kllktv.wndrs.de is not partially rewritten via wndrs.de
    sed -i "s#https://kllktv.wndrs.de#${origin}#g" "$f" || true
    sed -i "s#https://wndrs.de#${origin}#g" "$f" || true
  done

  # Keep OS out of the public index for both root and /site installs
  if [[ -f "$www/robots.txt" ]]; then
    grep -q 'Disallow: /os/' "$www/robots.txt" || sed -i '/^Allow: \/$/a Disallow: /os/' "$www/robots.txt" || true
    grep -q 'Disallow: /site/os/' "$www/robots.txt" || sed -i '/^Disallow: \/os\/$/a Disallow: /site/os/' "$www/robots.txt" || true
  fi
}

# Sync landing HTML tracker tags with collector config (site_key + path).
# Call after writing/restoring www/os/data/analytics/config.php.
wndrs_sync_landing_tracker() {
  local install_dir="${1:-$install_dir}"
  local path_prefix="${2:-${path:-/}}"
  local cfg="$install_dir/www/os/data/analytics/config.php"
  local landing_root="$install_dir/www"
  local site_key="" src

  path_prefix="${path_prefix%/}"
  [[ -n "$path_prefix" ]] || path_prefix=""
  src="${path_prefix}/os/a/t.js"

  if [[ -f "$cfg" ]]; then
    site_key="$(php -r '$c=require $argv[1]; echo $c["site_key"]??"";' "$cfg" 2>/dev/null || true)"
  fi
  if [[ -z "$site_key" ]]; then
    site_key="$(ynh_app_setting_get --key=site_key 2>/dev/null || true)"
  fi
  [[ -n "$site_key" ]] || return 0

  find "$landing_root" -maxdepth 2 -type f \( -name 'index.html' -o -name '*.html' \) \
    ! -path '*/os/*' -print0 2>/dev/null \
    | while IFS= read -r -d '' f; do
        if grep -q 'data-k=' "$f" 2>/dev/null || grep -q 't\.js' "$f" 2>/dev/null; then
          sed -i -E "s#src=\"[^\"]*t\\.js\"#src=\"${src}\"#g" "$f" || true
          if grep -q 'data-k=' "$f"; then
            sed -i -E "s#data-k=\"[^\"]*\"#data-k=\"${site_key}\"#g" "$f" || true
          else
            sed -i "s#</body>#    <script defer src=\"${src}\" data-k=\"${site_key}\"></script>\n  </body>#" "$f" || true
          fi
        fi
      done
}

# Dashboard must be reachable without Yunohost SSO (own login + TOTP).
wndrs_ensure_dashboard_public() {
  local dash_domain="${1:-${dashboard_domain:-}}"
  local app_id="${2:-$app}"
  [[ -n "$dash_domain" ]] || return 0

  ynh_permission_url --permission="dashboard" --url="${dash_domain}/" --auth_header=false || true
  ynh_permission_update --permission="dashboard" --add="visitors" || true
  # Helpers already pass force=True; tools shell is a YNH12 belt-and-suspenders fallback.
  yunohost tools shell -c "from yunohost.permission import user_permission_update, permission_url; user_permission_update('${app_id}.dashboard', add=['visitors'], force=True, protected=False); permission_url('${app_id}.dashboard', url='${dash_domain}/', auth_header=False)" 2>/dev/null || true
  yunohost app ssowatconf 2>/dev/null || true
}

# Seed / refresh the Python dashboard site so secrets match PHP collector config.
wndrs_ensure_dashboard_site() {
  local install_dir="${1:-$install_dir}"
  local domain_name="${2:-$domain}"
  local path_prefix="${3:-${path:-/}}"
  local dash_py="$install_dir/dashboard/.venv/bin/python"
  local cfg="$install_dir/www/os/data/analytics/config.php"
  local site_id site_key secret endpoint name

  [[ -x "$dash_py" && -f "$cfg" ]] || return 0

  path_prefix="${path_prefix%/}"
  endpoint="https://${domain_name}${path_prefix}/os/a/x.php"
  name="${domain_name}"

  site_id="$(php -r '$c=require $argv[1]; echo $c["site_id"]??"";' "$cfg" 2>/dev/null || true)"
  site_key="$(php -r '$c=require $argv[1]; echo $c["site_key"]??"";' "$cfg" 2>/dev/null || true)"
  secret="$(php -r '$c=require $argv[1]; echo $c["secret"]??"";' "$cfg" 2>/dev/null || true)"
  [[ -n "$site_id" && -n "$site_key" && -n "$secret" ]] || return 0

  (
    cd "$install_dir/dashboard"
    sudo -u "$app" "$dash_py" manage.py ensure-site \
      "$name" "$domain_name" "$endpoint" "$site_id" "$site_key" "$secret" "Europe/Berlin"
  ) || ynh_print_warn "ensure-site failed — create the site manually in the Python dashboard"
}

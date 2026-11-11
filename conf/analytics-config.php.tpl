<?php
declare(strict_types=1);

return [
    'site_id' => 'wndrs',
    'site_key' => '__SITE_KEY__',
    'secret' => '__ANALYTICS_SECRET__',
    'origins' => __ORIGINS_PHP__,
    'tz' => 'Europe/Berlin',
    'device_stats' => true,
    'visitor_mode' => 'hash',
    'geo_enabled' => false,
    'geo_db' => 'geo/GeoLite2-Country.mmdb',
    'retention_days' => 30,
];

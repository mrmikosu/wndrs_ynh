<?php
declare(strict_types=1);

// Absolute path: ynh templates collide with PHP magic constants named like DIR/FILE.
$root = '__INSTALL_DIR__/www/os';

return [
    'app_name' => 'WNDRS Kollektiv OS',
    'env' => 'production',
    'base_url' => '',
    'base_path' => '__BASE_PATH__',
    'url_query_router' => true,
    'public_home' => '__PUBLIC_HOME__',
    'timezone' => 'Europe/Berlin',
    'db' => [
        'dsn' => 'sqlite:' . $root . '/data/kollektiv.sqlite',
        'user' => null,
        'pass' => null,
    ],
    'session_name' => 'wndrs_session',
    'csrf_key' => '__CSRF_KEY__',
    'cookie_secure' => true,
    'cron_token' => '__CRON_TOKEN__',
    'mail_from' => '__ADMIN_EMAIL__',
    'mail_from_name' => 'WNDRS KLLKTV',
    'vapid_public' => '',
    'vapid_private' => '',
    'vapid_subject' => 'mailto:__ADMIN_EMAIL__',
    'upload_dir' => $root . '/uploads',
    'upload_url' => '__BASE_PATH__/uploads',
    'seed_admin_email' => '__ADMIN_EMAIL__',
    'seed_admin_password' => '__ADMIN_PASSWORD__',
    'seed_member_email' => 'member@localhost',
    'seed_member_password' => '__MEMBER_PASSWORD__',
    'seed_team_email' => 'team@localhost',
    'seed_team_password' => '__TEAM_PASSWORD__',
];

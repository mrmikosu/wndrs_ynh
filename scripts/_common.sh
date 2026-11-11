#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

# PHP version is exposed by resources.apt when php-fpm is installed.
# Fallback for helpers that expect $phpversion / $php_version.
phpversion="${phpversion:-${YNH_DEFAULT_PHP_VERSION:-8.3}}"

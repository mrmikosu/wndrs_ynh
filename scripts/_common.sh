#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

# $php_version is set by the apt resource when phpX.Y-fpm is listed in manifest.toml.
phpversion="${php_version:-${phpversion:-8.2}}"
php_version="${php_version:-$phpversion}"

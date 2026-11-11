#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

# $php_version is set by the apt resource when phpX.Y-fpm is listed in manifest.toml.
# Keep a fallback only for local shell checks.
phpversion="${php_version:-${phpversion:-8.2}}"

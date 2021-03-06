#!/bin/bash
set -e

usermod -u `stat -c %u /var/www/html` www-data || true
groupmod -g `stat -c %g /var/www/html` www-data || true

if [ ! -f web/js/config.js ]; then
    su www-data -s /bin/bash -c "cp web/js/config.js.dist web/js/config.js"
    su www-data -s /bin/bash -c "sed -i \"s#__TOGGLE_API_BASE_URL__#${TOGGLE__API_BASE_URL}#\" web/js/config.js"
fi

if [ "$1" = 'apache2-foreground' ]; then
    exec "$@"
else
    su www-data -s /bin/bash -c "$*"
fi

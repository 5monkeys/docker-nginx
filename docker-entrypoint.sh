#!/usr/bin/env sh
set -e

# Generate snakeoil certificate
if [ ! -f "/etc/nginx/ssl/cert.pem" ]; then
    echo "Generating snakeoil certificate..."
    mkdir -p /etc/nginx/ssl
    openssl req \
        -new \
        -nodes \
        -x509 \
        -days 3650 \
        -subj "/C=AU/ST=Some-State/O=Internet Widgits Pty Ltd" \
        -out /etc/nginx/ssl/cert.pem \
        -keyout /etc/nginx/ssl/key.pem
fi

# Render nginx templates
/render.sh

exec "$@"

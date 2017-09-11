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

# Render all .template files recursively found in /etc/nginx
#
# Finds uppercase variables only matching ${...} pattern, to not break
# and substitute nginx-variables, and then uses envsubst to create
# conf file in same dir as template.
for f in ${TEMPLATE_PATH:-/etc/nginx/**/*.template}; do
  if [ -f ${f} ]; then
    echo "Rendering template: ${f}"
    variables=$(echo $(grep -Eo '\${[A-Z_]+}' $f))
    envsubst "${variables}" < ${f} > ${f%.*}.conf;
  fi
done

exec "$@"

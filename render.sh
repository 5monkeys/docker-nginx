#!/usr/bin/env sh
set -e

# Render all .template files recursively found in /etc/nginx
#
# Finds uppercase variables only matching ${...} pattern, to not break
# and substitute nginx-variables, and then uses envsubst to create
# conf file in same dir as template.
if [ ! -z ${1} ]; then
  TEMPLATE_PATH=${1}
else
  TEMPLATE_PATH=${TEMPLATE_PATH:-/etc/nginx/**/*.template}
fi

echo "TEMPLATE_PATH: ${TEMPLATE_PATH}"

for f in ${TEMPLATE_PATH}; do
  if [ -f ${f} ]; then
    echo " - rendering: ${f}"
    variables=$(echo $(grep -Eo '\${[A-Z_]+}' $f))
    envsubst "${variables}" < ${f} > ${f%.*};
  fi
done

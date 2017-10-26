#!/usr/bin/env sh

render() {
    variables=$(grep -Eo '\${[A-Z0-9_]+}' ${1})
    envsubst "${variables}" < ${1} > ${1%.*}
    if ! diff ${1} ${1%.*} > /dev/null
    then
        mv ${1%.*} ${1}
        render ${1}
    fi
}

echo "Rendering templates:"
for f in ${TEMPLATE_PATH:-$@}; do
    if [ -f ${f} ];
    then
        echo "- ${f}"
        cp -f ${f} ${f}~
        render ${f}~
        rm ${f}~
    fi
done

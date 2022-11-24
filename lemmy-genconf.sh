#!/bin/bash
set -o errexit
set -o pipefail
if [ -z ${1+x} ]; then
    echo "Must provide an evironment name as argument."
    exit 1
fi
source $1.env
export DOLLAR="$" # Enables keeping $vars in nginx.conf.
cat lemmy.hjson.tpl | envsubst > lemmy.$1.hjson
cat nginx.conf.tpl | envsubst > nginx.$1.conf
echo "Wrote to lemmy.$1.hjson."
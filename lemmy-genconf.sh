#!/bin/bash
set -o errexit
set -o pipefail
if [ -z ${1+x} ]; then
    echo "Must provide an evironment name as argument."
    exit 1
fi
source $1.env
export DOLLAR="$" # Enables keeping $vars in nginx.conf.

if [ -f lemmy.$1.hjson ]; then
    echo "lemmy.$1.hjson already exists, skipping."
else
    cat lemmy.hjson.tpl | envsubst > lemmy.$1.hjson
    echo "Wrote to lemmy.$1.hjson."
fi 

if [ -f nginx.$1.conf ]; then
    echo "nginx.$1.conf already exists, skipping."
else
    cat nginx.conf.tpl | envsubst > nginx.$1.conf
    echo "Wrote to nginx.$1.conf."
fi 


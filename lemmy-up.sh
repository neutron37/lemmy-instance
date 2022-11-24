#!/bin/bash
set -o errexit
set -o pipefail
if [ -z ${1+x} ]; then
    echo "Must provide an evironment name as argument."
    exit 1
fi
./lemmy-genconf.sh $1
source $1.env
docker compose up

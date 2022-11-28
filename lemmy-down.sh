#!/bin/bash
set -o errexit
set -o pipefail
if [ -z ${1+x} ]; then
    echo "Must provide an evironment name as argument."
    exit 1
fi
source $1.env
if ! command -v docker-compose &> /dev/null; then
    docker compose down
else
    docker-compose down
fi

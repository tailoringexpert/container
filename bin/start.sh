#!/bin/sh
set -e

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
CONTAINER_DIR=$(dirname "$SCRIPT_DIR")
cd $CONTAINER_DIR

echo "starting platform"
docker-compose up -d
docker-compose logs
docker-compose ps

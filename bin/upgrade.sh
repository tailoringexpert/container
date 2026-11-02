#!/bin/sh
set -e

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
CONTAINER_DIR=$(dirname "$SCRIPT_DIR")
cd $CONTAINER_DIR

echo "installing following versions"
cat versions.properties

echo "stopping platform"
docker-compose down && docker-compose rm

echo "removing all tailoringexpert dependencies from local maven repository"
rm -rf ~/.m2/repository/eu

echo "removing all arsu dependencies from local maven repository"
rm -rf ~/.m2/repository/de/

echo "deleting non versioned artifacts"
git clean -df

echo "updating data"
git fetch
git rebase

echo "installing artifact"
./bin/mvn clean package
rm -rf target

echo "starting platform"
docker-compose up -d
docker-compose logs
docker-compose ps


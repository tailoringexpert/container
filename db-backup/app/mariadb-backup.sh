#!/bin/sh
# TARGET: Backup-Ziel
# IGNORE: Liste zu ignorierender Datenbanken (durch | getrennt)
# CONF: MySQL Config-Datei, welche die Zugangsdaten enthaelt
TARGET=/app/data
IGNORE="phpmyadmin|mysql|information_schema|performance_schema|test"


set -e

if [ -f ${SECRETS_FILE} ]; then
  echo "Using $SECRETS_FILE"
  export $(grep -v '^#' $SECRETS_FILE | xargs -0)
fi

MARIADB_HOST=$MARIADB_CONTAINER_NAME
MARIADB_PORT=$MARIADB_PORT
MARIADB_ROOT_USER=$MARIADB_ROOT_USER
MARIADB_ROOT_PASSWORD=$MARIADB_ROOT_PASSWORD

USER=$PUID:$PGID

if [ ! -d $TARGET ] || [ ! -w $TARGET ]; then echo "$0 - Backup-Verzeichnis nicht beschreibbar" > /proc/1/fd/1 2>/proc/1/fd/2 ; exit 1; fi

DBS="$(/usr/bin/mariadb -h $MARIADB_HOST --port $MARIADB_PORT -u $MARIADB_ROOT_USER -p${MARIADB_ROOT_PASSWORD}  -Bse 'show databases' | /bin/grep -Ev $IGNORE)"
NOW=$(date +"%Y%m%d")

for DB in $DBS; do
   echo "Dumping $DB..." > /proc/1/fd/1 2>/proc/1/fd/2
   /usr/bin/mariadb-dump -h $MARIADB_HOST --port $MARIADB_PORT -u $MARIADB_ROOT_USER -p${MARIADB_ROOT_PASSWORD} --skip-extended-insert --skip-comments $DB > $TARGET/$DB.sql
   chown $USER $TARGET/$DB.sql 
done

if [ ! -z $GIT_URL ]; then
    cd $TARGET
    /usr/bin/git add .  > /proc/1/fd/1 2>/proc/1/fd/2
    /usr/bin/git commit -m "$NOW"  > /proc/1/fd/1 2>/proc/1/fd/2
    /usr/bin/git push -u $GIT_URL > /proc/1/fd/1 2>/proc/1/fd/2
else 
  echo "No git url" > /proc/1/fd/1 2>/proc/1/fd/2
fi

echo "Backup von $NOW erfolgreich durchgefuehrt" > /proc/1/fd/1 2>/proc/1/fd/2
exit 0

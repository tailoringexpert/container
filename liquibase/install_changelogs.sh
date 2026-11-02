#!/bin/bash
set -e

if [ -f ${SECRETS_FILE} ]; then
  echo "Using $SECRETS_FILE"
  export $(grep -v '^#' $SECRETS_FILE | xargs -0)
fi 

if ! [ -z "$DEMODB_DATABASE" ]; then
  echo demo
  if ! [ -z "$CLEAR_CHECKSUMS" ]; then
    source /liquibase/liquibase --searchPath=/liquibase/changelog  --changeLogFile=db.changelog-demo.xml --url=$DATASOURCE_DEMO_URL --username=$DEMODB_USER --password=$DEMODB_PASSWORD  clear-checksums
  fi
  source /liquibase/liquibase --searchPath=/liquibase/changelog  --changeLogFile=db.changelog-demo.xml --url=$DATASOURCE_DEMO_URL --username=$DEMODB_USER --password=$DEMODB_PASSWORD  update
fi

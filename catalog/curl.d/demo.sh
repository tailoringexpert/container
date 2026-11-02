#!/bin/sh

set -e

if [ ! -z ${CATALOG_DEMO+x} ];
then
    TOKEN=$(curl -X POST \
        -k $IDM_URL/realms/$IDM_REALM/protocol/openid-connect/token \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -d username=demo \
        -d password=demo \
        -d grant_type=password \
        -d client_id=$IDM_CLIENTID)

    ACCESS_TOKEN=$(echo $TOKEN | jq -r .access_token)
    REFRESH_TOKEN=$(echo $TOKEN | jq -r .refesh_token)

    curl -X POST \
         -k $APP_URL/catalog \
         -d @/data/demo/$CATALOG_DEMO \
         --header "X-Tenant: demo" \
         --header 'Content-Type: application/json' \
         --header "Authorization: Bearer $ACCESS_TOKEN" \
         -v -L

   curl -X POST \
        -k $IDM_URL/realms/$IDM_REALM/protocol/openid-connect/logout \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -d refresh_token=$REFRESH_TOKEN \
        -d client_id=$IDM_CLIENTID


else 
   echo "DEMO catalog not impoorted"
fi

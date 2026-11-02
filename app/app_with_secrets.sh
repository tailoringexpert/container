#!/bin/bash

if [ -f ${SECRETS_FILE} ]; then
  echo "Using $SECRETS_FILE"
  export $(grep -v '^#' $SECRETS_FILE | xargs -0)
fi

# create data source property files -> vars are taken from secrets!
if [ ! -z ${DATASOURCE_DEMO_USERNAME+x} ];
then
  OUTFILE="/app/db/demo.properties"
  cat << 'EOF' > "$OUTFILE"
id=demo
name=demo datasource
type=org.springframework.jdbc.datasource.DriverManagerDataSource
spring.datasource.driver-class-name=org.mariadb.jdbc.Driver
spring.datasource.url=jdbc:mariadb://db:3306/tailoringexpert_demo
spring.datasource.username=${DATASOURCE_DEMO_USERNAME}
spring.datasource.password=${DATASOURCE_DEMO_PASSWORD}
EOF
else
  echo "DEMO datasource property file not created"
fi


exec java ${APP_AGENTLIB} -Dloader.path=file:/app/lib/,file:/app/tailoringexpert-platform.jar -Dspring.config.location=file:///app/config/  -Dlog4j2.configurationFile=file:///app/config/log4j2.xml -Djavax.net.ssl.trustStore=/app/lib/truststore  -jar /app/tailoringexpert-platform.jar


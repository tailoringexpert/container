#!/bin/bash

# (add your custom logic here)
if [ -f "${SECRETS_FILE}" ]; then
  echo "Using $SECRETS_FILE"
  # Liest die Datei Zeile für Zeile, ignoriert Kommentare und leere Zeilen
  while IFS= read -r line || [ -n "$line" ]; do
    [[ "$line" =~ ^#.* ]] && continue
    [[ -z "$line" ]] && continue
    export "$line"
  done < "$SECRETS_FILE"
fi

#if [ -f ${SECRETS_FILE} ]; then
#  echo "Using $SECRETS_FILE"
#  export $(grep -v '^#' $SECRETS_FILE | xargs -0)
#fi


# Run the 'exec' command as the last step of the script.
# As it replaces the current shell process, no additional shell commands will run after the 'exec' command.
exec /opt/keycloak/bin/kc.sh "$@"

#!/bin/bash

TRUSTSTORE_NAME=rds-truststore.pkcs12
TRUSTSTORE_PASSWORD=supersecretpassword

# Add certs to truststore
for CA in *.pem; do
  echo "Store: [${TRUSTSTORE_NAME}] - Importing [${CA}]"
  keytool -import -noprompt -trustcacerts -file "${CA}" -alias "${CA%%.*}" -storetype PKCS12 -keystore "${TRUSTSTORE_NAME}" -storepass "${TRUSTSTORE_PASSWORD}"
done
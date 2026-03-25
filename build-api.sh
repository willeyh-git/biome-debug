#!/usr/bin/env bash

readonly APIS_DIR='./apis'
readonly STATIC_CONFIG="$APIS_DIR/config.json"

readonly CONFIG_FILE="$APIS_DIR/generators.json"
readonly SPECS_FILE="$APIS_DIR/specs.json"
readonly RESULT_FILE="$APIS_DIR/result.nswag"

cat $STATIC_CONFIG >$CONFIG_FILE

curl --silent --insecure 'https://fakerestapi.azurewebsites.net/swagger/v1/swagger.json' >$SPECS_FILE
jq --rawfile specs "$SPECS_FILE" '.documentGenerator.fromDocument.json = $specs' $CONFIG_FILE >$RESULT_FILE

cd $APIS_DIR
npx nswag run
cd -

rm $CONFIG_FILE
rm $SPECS_FILE
rm $RESULT_FILE

#!/usr/bin/env bash
set -e

SCRIPT_DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
while [ -h "$SCRIPT_DIR/$0" ]; do
    DIR=$(dirname -- "$SCRIPT_DIR/$0")
    SYM=$(readlink $SCRIPT_DIR/$0)
    SCRIPT_DIR=$(cd $DIR && cd $(dirname -- "$SYM") && pwd)
done
BASEDIR="${SCRIPT_DIR}/.."

java -Djava.library.path=./DynamoDBLocal_lib -jar ${BASEDIR}/test/bin/dynamodb_local/DynamoDBLocal.jar -sharedDb

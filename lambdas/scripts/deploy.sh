#!/usr/bin/env bash
set -e

BASEDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
while [ -h "$BASEDIR/$0" ]; do
    DIR=$(dirname -- "$BASEDIR/$0")
    SYM=$(readlink $BASEDIR/$0)
    BASEDIR=$(cd $DIR && cd $(dirname -- "$SYM") && pwd)
done
cd $BASEDIR

echo "Packaging code bundle"
./build.sh

echo "Deploying lambda"
envchain aws-privat aws lambda update-function-code \
  --region eu-central-1 \
  --function-name arn:aws:lambda:eu-central-1:017978203355:function:game-chooser--${lambda_name} \
  --zip-file fileb://../build/package.zip

echo "Done"

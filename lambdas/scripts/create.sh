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

echo "Creating lambda"
envchain aws-privat aws lambda create-function \
  --region eu-central-1 \
  --function-name arn:aws:lambda:eu-central-1:017978203355:function:game-chooser--${lambda_name} \
  --zip-file fileb://build/package.zip \
  --role arn:aws:iam::017978203355:role/game-chooser--lambda-user \
  --handler main.handler \
  --runtime python2.7 \
  --timeout 20 \
  --memory-size 512

echo "Done"

#!/usr/bin/env bash
set -e

BASEDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
while [ -h "$BASEDIR/$0" ]; do
    DIR=$(dirname -- "$BASEDIR/$0")
    SYM=$(readlink $BASEDIR/$0)
    BASEDIR=$(cd $DIR && cd $(dirname -- "$SYM") && pwd)
done

echo "Performing preliminary checks"
lambda_name="$1"
if [ -z ${lambda_name} ]; then
  echo "Please specify lambda function (folder) to deploy."
  exit 1
fi

echo "Packaging code bundle"
cd "$BASEDIR"
rm -rf build/*
mkdir -p build
cd ${lambda_name}
zip $BASEDIR/build/package.zip *
cd ${VIRTUAL_ENV}/lib/python2.7/site-packages/
zip -r $BASEDIR/build/package.zip *
cd $BASEDIR

echo "Deploying lambda"
envchain aws-privat aws lambda update-function-code \
  --region eu-central-1 \
  --function-name arn:aws:lambda:eu-central-1:017978203355:function:game-chooser--${lambda_name} \
  --zip-file fileb://build/package.zip

echo "Done"

#!/usr/bin/env bash
set -e

BASEDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
while [ -h "$BASEDIR/$0" ]; do
    DIR=$(dirname -- "$BASEDIR/$0")
    SYM=$(readlink $BASEDIR/$0)
    BASEDIR=$(cd $DIR && cd $(dirname -- "$SYM") && pwd)
done
cd $BASEDIR/..

echo "Packaging code bundle"
./scripts/build.sh

echo "Deploying lambda"
envchain aws-privat aws cloudformation package \
  --s3-bucket game-chooser--lambda-bucket \
  --template-file template.yml \
  --output-template-file build/packaged.yml

envchain aws-privat aws cloudformation deploy \
  --template-file build/packaged.yml \
  --stack-name game-chooser

echo "Done"

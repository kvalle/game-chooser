#!/usr/bin/env bash
set -e

lambda_name="$1"

echo "Packaging code bundle"
cd ${lambda_name}
zip ../build/package.zip *
cd ..

echo "Deploying lambda"
envchain aws-privat aws lambda update-function-code \
  --region eu-central-1 \
  --function-name arn:aws:lambda:eu-central-1:017978203355:function:game-chooser--${lambda_name} \
  --zip-file fileb://build/package.zip

echo "Done"

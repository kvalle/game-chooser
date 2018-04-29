#!/usr/bin/env bash
set -e

lambda_name="$1"

echo "Packaging code bundle"
cd ${lambda_name}
zip ../build/package.zip *
cd ..

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

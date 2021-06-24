#!/bin/bash

AWS_ACCOUNT=$(aws sts get-caller-identity | jq -r '.Account')
LAMBDA_NAME=$(cat lambda-function-name)

./build-docker.sh

aws lambda update-function-code \
    --function-name ${LAMBDA_NAME} \
    --image-uri "${AWS_ACCOUNT}.dkr.ecr.us-west-2.amazonaws.com/${LAMBDA_NAME}:latest" \
    --publish

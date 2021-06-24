#!/bin/bash

set -e


AWS_ACCOUNT=$(aws sts get-caller-identity | jq -r '.Account')
LAMBDA_NAME=$(cat lambda-function-name)

aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.us-west-2.amazonaws.com

cd docker
docker build -t $LAMBDA_NAME .
docker tag $LAMBDA_NAME:latest ${AWS_ACCOUNT}.dkr.ecr.us-west-2.amazonaws.com/${LAMBDA_NAME}:latest
docker push ${AWS_ACCOUNT}.dkr.ecr.us-west-2.amazonaws.com/$LAMBDA_NAME:latest

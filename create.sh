#!/bin/bash

set -e

AWS_ACCOUNT=$(aws sts get-caller-identity | jq -r '.Account')
LAMBDA_NAME=$(cat lambda-function-name)

echo "###############################"
echo "## Creating Cloud Formation Stack"
echo

cd cloudformation
creation=$(aws cloudformation create-stack \
  --stack-name ${LAMBDA_NAME} \
  --template-body file://${LAMBDA_NAME}.yaml \
  --capabilities "CAPABILITY_IAM" "CAPABILITY_NAMED_IAM"  \
  --region us-west-2)
cd ..
echo $creation | jq
echo -n "waiting for template creation to complete..."
aws cloudformation wait stack-create-complete --stack-name ${LAMBDA_NAME}
echo "done."


echo
echo "###############################"
echo "## Building docker container, and pushing to ECR"
echo
./build-docker.sh


echo
echo "###############################"
echo "## Create lambda function and deploy"
echo
aws lambda create-function \
    --function-name ${LAMBDA_NAME} \
    --role "arn:aws:iam::${AWS_ACCOUNT}:role/${LAMBDA_NAME}" \
    --package-type Image \
    --code "ImageUri=${AWS_ACCOUNT}.dkr.ecr.us-west-2.amazonaws.com/${LAMBDA_NAME}:latest" \
    --region us-west-2


# lambda-function-docker

This is an example of creating a lambda function using docker container
as a packaging type.  

### Requirements
* Make sure you have the AWS cli tool installed.
* You need to have jq installed in order to process json 
* You need to have docker installed

### Setup

Run this script.
```bash
./create.sh
```
This will create two resources:
* CloudFormation stack that creates the following resources
    * ECR container registry
    * IAM Role used by the lambda function.
* Lambda Function

### Update function
1. Make any changes to your Dockerfile to install whatever tools
you need for your function to run properly.
2. Modify the startup.sh script to meet your needs.
```bash
./update.sh
```

### How it works
Your docker container can run whatever code you want.  Your defined ENTRYPOINT in the container
should run a script or application that follows this basic workflow:
* Run any initialization setup - this gets run once as a function is provisioned
* Start an endless loop that follows this:
  * call lambda runtime api - [Next Invocation](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html#runtimes-api-next)
    * Capture response header `Lambda-Runtime-Aws-Request-Id`
    * Capture api output (this is the json input to the function)
  * Do your logic
  * call lambda runtime api - [Invocation Response](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html#runtimes-api-response)
    * url to call requires the Request ID captured in the header of the next call
    * post JSON text to the api call containing the return value of your function

### Cleanup
1. Navigate to the ECR console in AWS, and Delete all ECR images
2. Delete the lambda function
3. Delete the Cloud Formation template.


### Notes on cost
* [Amazon Elastic Container Registry pricing](https://aws.amazon.com/ecr/pricing/)
* [AWS Lambda Pricing](https://aws.amazon.com/lambda/pricing/)
* **Summary:**  Deploying this function and CF will fall under the free tier 
for both ECR and lambda if running for some simple tests.
  

---
[Buy me a cup of coffee](https://www.buymeacoffee.com/rkhtech)
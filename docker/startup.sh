#!/bin/bash

###################### Add any initialization commands here that get run once at the start of a lambda function
# example:  fetch SSM parameters, build connection strings, etc...
echo "This gets run once during the function initialization."
###################### END Initialization section

while :  ## Loop forever
do
##################################################### This calls the lambda API, to fetch the next lambda call details
  OUT=$(mktemp)
  curl -s -i "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/next" > $OUT
  echo "" >> $OUT
  REQUEST_ID=$(cat $OUT | grep Lambda-Runtime-Aws-Request-Id | awk '{print $2}')
  DATA=$(cat $OUT | tail -n 1)
  echo "EVENT DATA: $DATA"   ## comment out if you don't want input values to appear in CloudWatch
  rm $OUT
#####################################################  BEGIN YOUR ROUTINE TO PROCESS DATA

  # Echo statements end up in the cloudwatch logs
  echo "Now let's do something with the data..."


  LAMBDA_OUTPUT_JSON=$DATA

##################################################### Call the lambda API to send a lambda response from your function call
  URL="http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/${REQUEST_ID}/response"
  echo $LAMBDA_OUTPUT_JSON | curl -s -X POST  $URL  -d @- >/dev/null
done


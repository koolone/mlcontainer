#!/bin/bash

endpoint=""
command=""
config=""

if [[ $1 = "local" ]]
then
   echo "Running local tests..."
   endpoint="http://localhost:8080/"
   command="curl"
else
   echo "Running remote tests..."
   endpoint="https://runtime.sagemaker.us-west-2.amazonaws.com/endpoints/demo-ml"
   config=" --region us-west-2 --service sagemaker "
   command="awscurl"
fi

echo "Issuing ping request..."
$command $config $endpoint/ping


echo "Issuing inference request..."
$command $config -d '{"text":"Hello world, this is a ML demo!", "k": 1}' -H "Content-Type: application/json" -X POST $endpoint/invocations


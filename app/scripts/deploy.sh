#!/bin/bash

STAGE=$1

CURRENT_DIR=$(pwd)
ROOT_DIR="$( dirname "${BASH_SOURCE[0]}" )"/..
echo "Deploying HMAC service to $STAGE."

export AWS_SECRET_ACCESS_KEY=$(aws sts assume-role --role-arn "arn:aws:iam::123456789012:role/cross-account-role" --role-session-name AWSCLI-Session  | jq -r '.Credentials[] | .SecretAccessKey'
export AWS_ACCESS_KEY_ID=$(aws sts assume-role --role-arn "arn:aws:iam::123456789012:role/cross-account-role" --role-session-name AWSCLI-Session  | jq -r '.Credentials[] | .AccessKeyId'
export AWS_SESSION_TOKEN=$(aws sts assume-role --role-arn "arn:aws:iam::123456789012:role/cross-account-role" --role-session-name AWSCLI-Session  | jq -r '.Credentials[] | .SessionToken'

cat ${ROOT_DIR}/parameters/${STAGE}-app-service | xargs aws cloudformation deploy --template-file ${ROOT_DIR}/cloudformation/app-service.cf.yaml --capabilities CAPABILITY_IAM
cat ${ROOT_DIR}/parameters/${STAGE}-app-endpoint | xargs aws cloudformation deploy --template-file ${ROOT_DIR}/cloudformation/app-endpoint.cf.yaml --capabilities CAPABILITY_IAM
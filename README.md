# App Pipeline


## Overview
   - This repository contains the following structure

   ![Alt text](./screen/directory.png?raw=true "Directory Structure")


## Workflow
   - The below workflow deploys 3 pipelines namely
     - pr-created
     - pr-merged
     - deploy

   ![Alt text](./screen/workflow.jpeg?raw=true "Pipeline Workflow")


## Assumptions
1. This APP deployment and pipeline has been setup to work with AWS
2. The shared secret that the container picks up will have to be first deployed to Secrets Manager and should be
referenced using the ARN   
3. The Github integration works fine on Buildkite agents. 
   1. HOW TO - setup rsa public and private ssh keys, copy them to the buildkite secrets bucket and 
   then deploy the buildkite-ci-stack on the AWS Account  
4. The Buildkite agent will have a hardened AMI that will be used for all builds across AWS Accounts.

## Deployment and RBAC
1. All IAM roles and permissions are and will be provisioned based on minimal access policy
2. For simplicity all workloads (including pipelines) have been defined for deployment in the same AWS account. This will change to the following model

Account | Stack | VPC | Role | 
--- | --- | --- | --- |
CD-PROD | buildkite-ci-stack | Public VPC | cd-deploy-role |
APP-DEV | dev-app-endpoint | Public VPC | cross-account-deploy-role |
APP-DEV | dev-app-service | Private VPC | cross-account-deploy-role |
APP-STG | stg-app-endpoint | Public VPC | cross-account-deploy-role |
APP-STG | stg-app-service | Private VPC | cross-account-deploy-role |
APP-PROD | prod-app-endpoint | Public VPC | cross-account-deploy-role |
APP-PROD | prod-app-service | Private VPC | cross-account-deploy-role |
* Public VPCs are classified as untrusted zones and will stay disconnected. The services in Private VPC is accessible only via privatelink.


## Fixes Made to App
1. Defined stats map in main.go
2. Updated token function to return json in handler.go

```
For build purposes, use export SECRET=<value> and thenpass it as an arg using command:
       docker build --tag <image-name>:latest . --file app/Dockerfile --build-arg secret=$SECRET
Run the above cmd from root directory of this repo
```
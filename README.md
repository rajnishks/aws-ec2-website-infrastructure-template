# aws-ec2-static-website-template
A template for deploying and maintaining static websites in AWS EC2 environment.

## OBJECTIVE
The purpose of this starter template is to demonstrate how a static website can be deployed and maintained in AWS using EC2 servers.

_Note: There are alternative ways of running static websites in AWS that are simpler and recommended, as an example static websites can be easily deployed and delivered via S3_

## HOW TO USE?

### Pre-requisites
In order to run the application, the following must be completed before initiating setup / deployment:
* Install Node 10 and above (https://nodejs.org/en/download/ or https://github.com/nvm-sh/nvm)
* Install AWS CLI Latest (https://aws.amazon.com/cli/)
* Setup AWS CLI profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
* Create an EC2 keypair (https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)

### AWS Permissions
For an AWS account to execute the below steps, the following permissions must be provided to the IAM user running the scripts:
TBD

### Installation Steps
Please follow the below steps:
* Clone the repository
* Update the infrastructure templates as per your requirement (detail below).
* Update the "src" folder with code required to run your web application.
    * For demonstration purposes, this repository uses a free website template created by designmodo - https://github.com/designmodo/html-website-templates
* To deploy the application, run the following command:
    * Run "npm install" to install the dependencies
    * For deployment via cloudfront: npm run deploy:cfn
    * For deployment via terraform: npm run deploy:tf
    * For deployment via cdk: npm run deploy:cdk
* The URL of the deployed application is available in cloudformation stack output.
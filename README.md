# aws-ec2-static-website-template
A template for deploying and maintaining static websites in AWS EC2 environment.

## OBJECTIVE
The purpose of this starter template is to demonstrate how a static website can be deployed and maintained in AWS using EC2 servers.

_Note: There are alternative ways of running static websites in AWS that are simpler and recommended, as an example static websites can be easily deployed and delivered via S3_

## TECHNICAL ARCHITECTURE
The following diagram represents the architecture setup in the AWS environment

![Infrastructure Diagram](images/aws-simple-ec2-app.png)

## HOW TO USE?

### Pre-requisites
In order to run the application, the following must be completed before initiating setup / deployment:
* Install AWS CLI Latest (https://aws.amazon.com/cli/)
* Setup AWS CLI profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
* Create an EC2 keypair (https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)

### AWS Permissions
For an AWS account to execute the below steps, the following permissions must be provided to the IAM user running the scripts:
TBD

### Installation Steps
Please follow the below steps:
* Configure the infrastructure by changing the arguments available in master.yaml. 
* Update the "src" folder with code required to run your web application.
    * For demonstration purposes, this repository uses a free website template created by designmodo - https://github.com/designmodo/html-website-templates
* To manage the application via cloudformation, use the following commands:
    * To deploy stack: aws cloudformation create-stack --stack-name={stack-name} --profile={profile-name} --template-body=file://deploy/cloud-formation/master.yaml
    * To delete stack: aws cloudformation delete-stack --stack-name={stack-name} --profile={profile-name}
    * To validate stack: aws cloudformation validate-template --template-body=file://deploy/master.yaml
* The URL of the deployed application is available in cloudformation stack output.
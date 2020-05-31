# aws-ec2-webapp-iaac-template

## OBJECTIVE
The purpose of this starter template is to demonstrate how a webapp can be deployed and maintained in AWS.

Action Items
0. How do you do monitoring? Is logging sufficient? Error scenarios?
1. Reframe objective, github url
2. Add section for Terraform, CDK..comparison between the three
3. Evaluate quality of aws infrastructure - well architected framework

### Audience
To showcase how applications can be deployed, I have used the following starter toolkit: https://github.com/facebook/create-react-app. The deployment approach shown in this template does not depend on the type of framework chosen. You are free to choose any other kind of framework - angular, vue etc.

Once a framework is chosen, the next challenge for an organization is to define an approach for managing the web application in a cloud environment - AWS, Azure etc. Navigating a cloud envionment, say AWS, is not an easy task. There are considerations around security, performance, scalability, monitoring etc. This template showcases one way in which such an application can be deployed in AWS keeping in mind the best practices.

### Approach
There are multiple ways in which a web application can be deployed in AWS -
1. Deployment in EC2 server with cloud front integration
2. Deployment in S3 with cloud front integration and using API-Gateway / Lambda for APIs (a.k.a serverless approach)
3. Deployment usng Elastic Beanstalk
4. Deployment using LightSail
5. Deployment using ECS
6. Deployment using EKS
7. ...
8. ...

All the above approaches have their pros and cons. This template focuses on approach #1 for deploying and running the web application. At the same time, I must add that there are lot of approaches - serverless approach (i.e. use of S3, Lambda) that do have an advantage ove the approach suggested in this template.

## TECHNICAL DETAILS
The template starts with a most basic installation setup in AWS required to run a 24*7 website - two EC2 servers running in different availability zones managed by a load balancer (refer diagram below). However, configuration is provided to increase the scale of the system.

![Infrastructure Diagram](images/aws-simple-ec2-app.png)

In summary, the following infrastructure is being created:
1. EC2 servers deployed in different AZs registered with a load balancer.
2. Servers deployed in Auto Scaling Group to ensure the specified minimum number of servers are always active. 
3. EC2 servers running in private subnets to ensure instances are always secure.
4. Use of NAT Gateway to route EC2 server requests to internet (for getting updates or any additional request to the internet).
5. Enabling developer to SSH into the EC2 servers using AWS Systems Manager.
6. Use of Cloud watch for monitoring purposes.
7. Enabling CloudTrail to support auditing requirements.

For ease of customizing this enviornment, the template provides infrastructure automation scripts using three tools:
1. AWS Cloud Formation
2. AWS CDK
3. Terraform

The rationale for writing the automation scripts in three tools was purely driven by "academic" reasons - primarily to evaluate how the three approaches differ from each other. A developer can pick and choose any of the three scripts to customize the environment as per their needs.

### Cost
The best way to understand the cost to deployment is to refer the following cost estimate in pricing calculator: https://calculator.aws/#/estimate?id=bd696a769989e1fad4bfbbec61991ebc5eb0c2b5

The actual cost may be different from the estimated cost. Some of the primary factors which could influence the actual cost are:
1. Region: The cost may change if a different region is choosen. Prices of EC2 services vary by region.
2. EC2 Cost
    * The cost will increase if a costlier EC2 server is used for running the application
    * If the number of EC2 servers choosen to run the application increases, the cost will increase.
    * Keep an eye on the baseline vCPU allocated to an instance. If the real time usage shows a different pattern, you may need to change the instance type: https://d2908q01vomqb2.cloudfront.net/da4b9237bacccdf19c0760cab7aec4a8359010b0/2018/08/23/T3_2.png 
3. Data Transfer Cost
    * If the amount of data transfer is more than anticipated in the estimated model, cost will increase.
4. NAT Gateway
    * The cost will increase if utilization increases beyond the estimated usage. 

## HOW TO USE?

### Pre-requisites
In order to run the application, the following must be completed before initiating setup / deployment:
* Install Node 10 and above (https://nodejs.org/en/download/ or https://github.com/nvm-sh/nvm)
* Install AWS CLI Latest (https://aws.amazon.com/cli/)
* Setup AWS CLI profile, specify credentials as well as preferred region (https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

### AWS Permissions
For an AWS account to execute the below steps, the following permissions must be provided to the IAM user running the scripts:
TBD

### Installation Steps
Please follow the below steps:
* Update the infrastructure templates as per your requirement.
    * Once the changes are made, push the nested stack templates (i.e. application.yaml, security-groups.yaml and vpc.yaml) to a S3 public bucket of your choice.
    * Update the URL of these templates in master.yaml
    * Update UserData attribute in LaunchConfig node of application.yaml as per requirement.
    * Validate the template using "npm run stack:validate"
* Update the "aws" attribute in package json with configuration specific details
    * Stack name for setting up the cloudformation stack
    * AWS profile to be used while invoking the cloudformation 
* Update the "web" folder with code required to run your web application. Note that the following steps are custom to the "react-boilerplate-typescript" template
    * Run "cd web"
    * Run "npm run build"
    * Run "git commit -a -m '<commit message>'"
    * Run "git push origin"
* To deploy the application, run the following command:
    * Run "npm install" to install the dependencies
    * For deployment via cloudfront: npm run deploy:cfn
    * For deployment via terraform: npm run deploy:tf
    * For deployment via cdk: npm run deploy:cdk
* The URL of the deployed application is available in cloudformation stack output.

--------------------- Terraform Notes -------------------
Download terraform, add to path (if downloaded manually)
Run "cd deploy/terraform & terraform init"
Run "cd deploy/terraform & terraform apply"

Pros
- Uplifting that the infrastructure will work across all cloud, great control

Cons
- Revert not happing, cloudformation does itki9i9u9ujiiiu78y87uyfrgdyd

## WELL ARCHITECTED FRAMEWORK
TBD

## FUTURE EXTENSIONS
The following extensions can be made to improve the quality of the template:
1. Support for CI-CD workflow
2. Added tests to check the validity of the templates

## References
The following articles / examples were referred while creating this template:
* https://aws.amazon.com/blogs/infrastructure-and-automation/best-practices-for-deploying-ec2-instances-with-aws-cloudformation/
* https://aws.amazon.com/blogs/infrastructure-and-automation/toward-a-bastion-less-world/
* https://github.com/aws-quickstart/quickstart-examples/blob/master/samples/session-manager-ssh/session-manager-ssh-example.yaml
* https://www.theguild.nl/cost-saving-with-nat-instances/
* https://cloudonaut.io/6-new-ways-to-reduce-your-AWS-bill-with-little-effort/
* https://aws.amazon.com/blogs/compute/building-a-dynamic-dns-for-route-53-using-cloudwatch-events-and-lambda/
* https://gist.github.com/Can-Sahin/d7de7e2ff5c1a39b82ced2d9bd7c60ae
* https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/continuous-delivery-codepipeline-basic-walkthrough.html
* https://github.com/symphoniacloud/multi-region-codepipeline
* https://github.com/Hallian/codedeploy-example/blob/master/webapp.cloudformation.yml
* https://aws.amazon.com/blogs/devops/automatically-deploy-from-amazon-s3-using-aws-codedeploy/
* https://aws.amazon.com/blogs/infrastructure-and-automation/best-practices-for-deploying-ec2-instances-with-aws-cloudformation/
* https://github.com/aws-samples/ecs-refarch-cloudformation
* https://aws.amazon.com/blogs/networking-and-content-delivery/dynamic-whole-site-delivery-with-amazon-cloudfront/
* https://github.com/widdix/aws-cf-templates
* https://www.youtube.com/watch?v=zkNdHv1iMgY
* https://aws.amazon.com/blogs/infrastructure-and-automation/amazon-s3-authenticated-bootstrapping-in-aws-cloudformation/
* https://www.trek10.com/blog/beginners-guide-to-using-terraform-with-aws
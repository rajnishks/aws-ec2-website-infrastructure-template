'use strict';

const AWS = require('aws-sdk');
const awsProfile = process.argv[2]; //the aws profile to be used
const awsRegion = process.argv[3]; //the aws region for deployment
const stackName = process.argv[4]; //the cloudfront stack name

async function cacheInvalidate(
    stack_name,
	invalidateList = ['/*'], // default to invalidate everything
	callerReference = Date.now().toString(), // AWS needs a unique value for some reason
) {

    try {

        const credentials = new AWS.SharedIniFileCredentials({profile: awsProfile});
        AWS.config.credentials = credentials;

        const cloudformation = new AWS.CloudFormation({apiVersion: '2010-05-15', region: awsRegion});
        var params = {
            StackName: stackName
        };

        const data = await cloudformation.describeStacks(params).promise();
        
        if (data.Stacks.length === 0)
            throw new Error("Not able to find the relevant stack.");

        var distributionId;
        data.Stacks[0].Outputs.forEach(element => {
            if (element.OutputKey === 'CloudFrontDistributionId') {
                distributionId = element.OutputValue;
            }
        });

        if (distributionId == null)
            throw new Error("Not able to find the cloudfront distribution id from stack details. Please export this attribute in output ");

        const cloudfront = new AWS.CloudFront({region: 'us-east-1'});
		await cloudfront.createInvalidation({
			DistributionId: distributionId,
			InvalidationBatch: {
				CallerReference: callerReference,
				Paths: {
				    Quantity: invalidateList.length,
			        Items: invalidateList
				}
		    }
        }).promise();
        
        console.log('successfully invalidated cloudfront cache');

    } catch (e) {
        console.log(e, e.stack);
    }

};

cacheInvalidate(process.argv[2]);
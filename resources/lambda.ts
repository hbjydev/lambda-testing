import * as aws from '@pulumi/aws';
import * as pulumi from '@pulumi/pulumi';

const lambdaRole = new aws.iam.Role("lambdaRole", {
  assumeRolePolicy: {
    Version: "2012-10-17",
    Statement: [
      {
        Action: "sts:AssumeRole",
        Principal: {
          Service: "lambda.amazonaws.com",
        },
        Effect: "Allow",
        Sid: "",
      },
    ],
  },
});

new aws.iam.RolePolicyAttachment("lambdaRoleAttachment", {
  role: lambdaRole,
  policyArn: aws.iam.ManagedPolicy.AWSLambdaBasicExecutionRole,
});

// Create the Lambda to execute
const lambda = new aws.lambda.Function("lambdaFunction", {
  code: new pulumi.asset.AssetArchive({
    ".": new pulumi.asset.FileArchive("./app"),
  }),
  runtime: "nodejs12.x",
  role: lambdaRole.arn,
  handler: "index.handler",
});

// Give API Gateway permissions to invoke the Lambda
new aws.lambda.Permission("lambdaPermission", {
  action: "lambda:InvokeFunction",
  principal: "apigateway.amazonaws.com",
  function: lambda,
});

export const endpoints = new aws.apigatewayv2.Api("httpGw", {
  protocolType: 'HTTP',
  routeKey: "GET /",
  target: lambda.invokeArn,
});

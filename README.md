# aws-lambda-ruby-layers

aws-lambda-ruby-layers is a sample project that explores AWS Lambda Layers and Lambda support for Ruby, both introduced at re:Invent 2018.

Accompanying blog post: [Exploring AWS Lambda Layers and Ruby Support](https://medium.com/@joshua.a.kahn/exploring-aws-lambda-layers-and-ruby-support-5510f81b4d14)

## Getting Started

To get started, clone this repository:

``` bash
$ git clone https://github.com/jkahn117/aws-lambda-ruby-layers
```

### Prerequisites

This project requires the following to get started:

* Select an AWS Region into which you will deploy services.
* [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html) and all of its dependencies (e.g. Docker, Python).

## Create AWS Resources

We will use the AWS Serverless Application Model to package an deploy our AWS resources. Before deploying, we need to build our simple Lambda Layer, which includes the HTTParty Ruby Gem and simple shared code:

``` bash
$ cd layer

$ ./build.sh
```

The build script will briefly create a Docker container and build all Ruby Gems before organizing the files per the Lambda Layers specification and compressing to a zip file named `layer.zip`. SAM will take care of deploying the Layer zip file as well as the configuring necessary permissions for our Lambda function to use the Layer.

To deploy:

``` bash
$ aws s3 mb s3:<MY_UNIQUE_BUCKET_NAME>

$ sam build

$ sam package --ouput-template-file packaged.yaml \
              --s3-bucket <MY_UNIQUE_BUCKET_NAME>

$ sam deploy  --template-file packaged.yaml \
              --stack-name lambda-ruby-layers \
              --capabilities CAPABILITY_IAM
```

Once complete, we can retrieve the unique API endpoint of our function to invoke it remotely or use the AWS Console to verify the function works as expected.

``` bash
$ aws cloudformation describe-stacks --stack-name lambda-ruby-layers \
              --query "Stacks[0].Outputs[?OutputKey=='MyApi'].OutputValue"
```

To test the function, copy the resulting URL (e.g. https://abcdefg.execute-api.us-east-1.amazonaws.com/Prod/hello/) from the above command and paste in your favorite browser. The result should be a JSON payload such as:

``` json
{"message":"Go Ruby with Layers!", "location":"123.45.6.78\n"}
```

Specific to the Layer, the function uses the HTTParty Gem as well as a method (`build_response`) in a shared file to build the API response. The API would return a 500 error if the Layer did not provide this functionality.

## Cleaning Up

To clean-up all resources associated with this project (i.e. delete all resources), enter the following:

``` bash
$ aws cloudformation delete-stack --stack-name lambda-ruby-layers
```

## Authors

* **Josh Kahn** - *Initial work*
# devops-test-helloworld-app

This folder contains all code related to infra and code deployment for Adevinta DevOps test. 

# Dependencies
* `Terraform`: Version 0.11.14 or higher is required. You can get it at https://releases.hashicorp.com/terraform/0.11.14/
* `Python3`

# Requirements
* You must set your aws_region, aws_access_key_id and aws_secret_access_key on terraform/environments/prd/prd.tfvars
* You could define your aws environment creating a credentials file inside your $HOME/.aws/credentials file

It looks like this:

[default]
aws_access_key_id = 
aws_secret_access_key = 

* an S3 bucket dedicated for centralized logging will be created by infra init script. It will be named as helloworldtest-logs
* You need to create a new AWS keyPair named "helloworld". It will be used later in order to manage all AWS stuff.

# Deploy infrastructure

* Execute ./infra.sh script. It will create all resources needed for the app to run.

# Deploy code

* Use ./deploy.py script in order to execute a blue/green deploy. Script will launch a new parallel stack with new code cloned from master branch. However, it could be improved cheking for all healthy instances before switching traffic to the new stack.

 usage: deploy.py <aws_region>



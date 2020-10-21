#!/bin/bash

WORKDIR="terraform/environments/prd/helloworld"
cd ${WORKDIR}
terraform init
terraform apply -var-file=../prd.tfvars

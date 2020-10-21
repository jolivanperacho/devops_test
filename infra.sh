#!/bin/bash

WORKDIR="terraform/environments/prd/helloworld"
cd ${WORKDIR}
terraform apply -var-file=../prd.tfvars

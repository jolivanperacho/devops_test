#!/usr/bin/env bash

# Config
DIR_SSH=/root/.ssh
DIR_GIT=/root/deployments
AWS_REGION=`wget -qO- http://instance-data/latest/meta-data/placement/availability-zone | sed 's/.$//'`
export HOME=/root

# Clone Deployments repository
git clone -b master https://github.com/scm-spain/devops-test-helloworld-app.git $DIR_GIT/


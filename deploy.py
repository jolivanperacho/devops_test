#!/usr/local/bin/python3

import boto3
import argparse
import time

parser = argparse.ArgumentParser("deploy")
parser.add_argument("region", help="AWS region to deploy", type=str)
args = parser.parse_args()

def as_get_instances(client, asgroup, NextToken = None):

    irsp = None
    if NextToken:
        irsp = client.describe_auto_scaling_instances(NextToken=NextToken)
    else:
        irsp = client.describe_auto_scaling_instances()

    for i in irsp['AutoScalingInstances']:
        if i['AutoScalingGroupName'] == asgroup:
            yield i['InstanceId']

    if 'NextToken' in irsp:
        for i in as_get_instances(client, asgroup, NextToken = irsp['NextToken']):
            yield i


if __name__ == '__main__':
    client = boto3.client('autoscaling', region_name=args.region)
    current_instances = len(list(as_get_instances(client, 'prd-helloworld-prod')))
    desired = current_instances * 2
    print("Creating new stack of " + str(desired) + " instances...")

    client.update_auto_scaling_group(
        AutoScalingGroupName="prd-helloworld-prod",
        DesiredCapacity=desired,
        MaxSize=desired,
    )

# lo ideal aquí para una app en prod sería sacar la lista de instancias attached al targetgroup y esperar hasta que el health de todas ellas estuviera en healthy

    time.sleep(90)

    client.update_auto_scaling_group(
        AutoScalingGroupName="prd-helloworld-prod",
        DesiredCapacity=current_instances,
    )

    while len(list(as_get_instances(client, 'prd-helloworld-prod'))) > current_instances:
       print("shrinking stack...")
       time.sleep(5)
      
    print("Deploy done!")
   

   

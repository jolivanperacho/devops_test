variable "application" {
  default = "helloworld"
}

variable "group" {
  default = "java"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "data_bucket_arn" {
  default = "arn:aws:s3:::helloworld-prd"
}

variable "environment" {
  default = "prd"
}

variable "asg" {
  type = "map"

  default = {
    min_size         = 1
    max_size         = 2
    desired_capacity = 1
  }
}

variable "region" {
  default = "eu-west-2"
}

variable "bbdd_address" {
}

variable "key_name" {}
variable "subnets" {}
variable "subnet_backup" {}
variable "autoscaling_schedule" {}
variable "vpc" {}
variable "env" {}
variable "hosted_zone" {}
variable "access_key" {}
variable "secret_key" {}

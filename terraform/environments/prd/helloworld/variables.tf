variable "environment" {}
variable "env" {}
variable "hosted_zone" {}
variable "key_name" {}
variable "region" {}
variable "access_key" {}
variable "secret_key" {}
variable "asg" {
  type = "map"

  default = {
    min_size         = 1
    max_size         = 2
    desired_capacity = 1
  }
}
variable "instance_type" {
  default = "t3.medium"
}

variable "cidr_block" {
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  default     = "10.0.0.0/24"
}

variable "availability_zone" {
  default     = "eu-west-2a"
}

variable "availability_zone_backup" {
  default     = "eu-west-2b"
}

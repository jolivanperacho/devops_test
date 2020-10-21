provider "aws" {
  region  = "${var.region}"
  version = "~> 1.43"
}

terraform {
	required_version = ">= 0.11.11"
}

resource "aws_vpc" "selected" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "selected" {
  vpc_id = "${aws_vpc.selected.id}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.selected.id}"
}

resource "aws_route" "public" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.selected.id}"
}

resource "aws_subnet" "public" {

  vpc_id                  = "${aws_vpc.selected.id}"
  cidr_block              = "${var.public_subnet_cidr_block}"
  availability_zone       = "${var.availability_zone}"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "backup" {

  vpc_id                  = "${aws_vpc.selected.id}"
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.availability_zone_backup}"
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "public" {

  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

# RDS postgreSQL

locals {
  resource_name_prefix = "helloworld"
}

resource "aws_db_subnet_group" "bbdd_group" {
  name       = "${local.resource_name_prefix}-subnet-group"
  subnet_ids = ["${aws_subnet.public.id}","${aws_subnet.backup.id}"]
}

resource "aws_security_group" "open_postgresql" {
    vpc_id = "${aws_vpc.selected.id}"
    ingress {
        protocol = "TCP"
        from_port = 5432
        to_port = 5432
        cidr_blocks = ["10.0.0.0/8"]
    }
}

resource "aws_db_instance" "postgresql" {
  allocated_storage    = 100
  db_subnet_group_name = "${aws_db_subnet_group.bbdd_group.id}"
  engine               = "postgres"
  engine_version       = "11.5"
  identifier           = "postgresql"
  instance_class       = "db.t3.micro"
  password             = "d1g1t4ln0c-"
  skip_final_snapshot  = true
  storage_encrypted    = true
  username             = "postgres"
  publicly_accessible  = true
  vpc_security_group_ids = ["${aws_security_group.open_postgresql.id}"]
}

module "helloworld" {
  source      = "../../../modules/helloworld"
  env         = "${var.env}"
  environment         = "${var.environment}"
  vpc         = "${aws_vpc.selected.id}"
  subnets     = "${aws_subnet.public.id}"
  subnet_backup = "${aws_subnet.backup.id}"
  key_name    = "${var.key_name}"
  hosted_zone = "${var.hosted_zone}"
  asg         = "${var.asg}"
  autoscaling_schedule = false
  instance_type = "${var.instance_type}"
  bbdd_address  = "${aws_db_instance.postgresql.endpoint}"
  access_key    = "${var.access_key}"
  region        = "${var.region}"
  secret_key    = "${var.secret_key}"
}

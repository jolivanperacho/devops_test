# This creates 2 IAM role policies which allow:
resource "aws_iam_instance_profile" "iam_ec2_profile" {
  name = "${var.application}-${var.environment}"
  role = "${aws_iam_role.ec2.name}"
}

data "aws_iam_policy_document" "iam_for_ec2_policy_document" {
  "statement" {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2" {
  name               = "${var.application}-${var.environment}"
  assume_role_policy = "${data.aws_iam_policy_document.iam_for_ec2_policy_document.json}"
}

data "aws_iam_policy_document" "s3bucket_assume_role_policy" {
  "statement" {
    actions = ["s3:*"]
    effect  = "Allow"

    resources = [
      "${var.data_bucket_arn}",
      "${var.data_bucket_arn}/*",
    ]
  }
}

resource "aws_s3_bucket" "helloworldtest-logs" {
  bucket = "helloworldtest-logs"
  acl = "public-read"
}

resource "aws_s3_bucket_public_access_block" "s3Public" {
  bucket = "${aws_s3_bucket.helloworldtest-logs.id}"
  block_public_acls = false
  block_public_policy = false
  restrict_public_buckets = false
}


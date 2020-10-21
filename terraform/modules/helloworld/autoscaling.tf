# Define a launch-config for this role:
resource "aws_launch_configuration" "helloworld-prd" {
  name_prefix                 = "${var.group}-${var.application}-${var.environment}-"
  image_id                    = "${data.aws_ami.amazon-linux-2.id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${aws_iam_instance_profile.iam_ec2_profile.id}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.instances.id}"]
  enable_monitoring           = false
  associate_public_ip_address = true
  user_data                   = "${data.template_file.cloudinit.rendered}"

  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Define an autoscaling-group:
resource "aws_autoscaling_group" "helloworld-prd" {
  availability_zones        = ["${data.aws_availability_zones.available.names[count.index]}"]
  name                      = "${var.env}-${var.application}-${var.environment}"
  max_size                  = "${var.asg["max_size"]}"
  min_size                  = "${var.asg["min_size"]}"
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = "${var.asg["desired_capacity"]}"
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.helloworld-prd.name}"
  vpc_zone_identifier       = ["${var.subnets}"]
  termination_policies      = ["OldestInstance"]
  target_group_arns = [
    "${aws_lb_target_group.helloworld-prd_lb_target_group.arn}",
  ]
  tag {
    key                 = "Name"
    value               = "${var.group}-${var.application}-${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Group"
    value               = "${var.group}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Application"
    value               = "${var.application}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }
}

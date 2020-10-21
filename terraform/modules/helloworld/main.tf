resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${var.vpc}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
#Internet ALB
resource "aws_lb" "helloworld-prd_lb" {
  name               = "${var.env}-helloworld-alb"
  subnets            = ["${var.subnets}","${var.subnet_backup}"]
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.allow_tls.id}"]
  enable_deletion_protection = true

  tags {
    Name = "${var.env}-helloworld-alb"
  }
}

resource "aws_lb_target_group" "helloworld-prd_lb_target_group" {
  name        = "${var.env}-helloworld-tg"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = "${var.vpc}"
  target_type = "instance"

  health_check {
    port     = "traffic-port"
    protocol = "HTTP"
    interval = "5"
    path     = "/"
    timeout  = 3
  }

  tags {
    Name = "${var.env}-helloworld-alb"
  }
}

resource "aws_lb_listener" "helloworld-prd_lb_listener_80" {
  "default_action" {
    target_group_arn = "${aws_lb_target_group.helloworld-prd_lb_target_group.arn}"
    type             = "forward"
  }

  load_balancer_arn = "${aws_lb.helloworld-prd_lb.arn}"
  port              = "80"
  protocol          = "HTTP"
}

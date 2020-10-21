# need to open ports
# 80 -> HTTP
# 22 -> ssh
resource "aws_security_group" "instances" {
  name        = "${var.environment}-${var.application}"
  description = "For ${var.environment}-${var.application} instances"
  vpc_id      = "${var.vpc}"

  tags {
    Name = "${var.environment}-${var.application}"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "dev-ec2-sg" {
  description = "Controls direct access to application instances (EC2)"
  vpc_id      = aws_vpc.dev-vpc.id
  name        = "dev-ec2-sg"

  ingress {
    protocol    = "tcp"
    from_port   = 32768
    to_port     = 65535
    cidr_blocks = ["0.0.0.0/0"]
    description = "Load Balancer Access"
  }
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "dev-alb-sg" {
  description = "Controls access to the application ELB"
  vpc_id = aws_vpc.dev-vpc.id
  name   = "dev-alb-sg"

  ingress {
    protocol    = "tcp"
    from_port   = 8900
    to_port     = 8900
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 8901
    to_port     = 8901
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
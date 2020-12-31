resource "aws_security_group" "aws-dev-ec2-sg" {
  description = "Controls direct access to application instances (EC2)"
  vpc_id      = aws_vpc.aws-dev-vpc.id
  name        = "aws-dev-ec2-sg"

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

resource "aws_security_group" "aws-dev-alb-sg" {
  description = "Controls access to the application ELB"
  vpc_id = aws_vpc.aws-dev-vpc.id
  name   = "aws-dev-alb-sg"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
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
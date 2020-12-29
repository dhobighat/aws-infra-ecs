resource "aws_security_group" "instance_sg" {
  description = "controls direct access to application instances"
  vpc_id      = aws_vpc.aws-dev-vpc.id
  name        = "application-instances-sg"

  ingress {
    protocol    = "tcp"
    from_port   = 8000
    to_port     = 8000
    cidr_blocks = ["0.0.0.0/0"]
    description = "Access to the application"
  }
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
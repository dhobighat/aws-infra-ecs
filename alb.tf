## ALB
resource "aws_alb" "aws-dev-alb" {
  name            = "aws-dev-alb"
  subnets         = [aws_subnet.aws-dev-subnet-1.id, aws_subnet.aws-dev-subnet-2.id]
  security_groups = [aws_security_group.aws-dev-alb-sg.id]
  enable_http2    = "true"
  idle_timeout    = 600
}
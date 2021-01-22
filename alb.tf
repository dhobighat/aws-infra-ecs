## ALB
resource "aws_alb" "dev-alb" {
  name            = "dhobhighat-dev"
  subnets         = [aws_subnet.dev-subnet-1.id, aws_subnet.dev-subnet-2.id]
  security_groups = [aws_security_group.dev-alb-sg.id]
  enable_http2    = "true"
  idle_timeout    = 600

}



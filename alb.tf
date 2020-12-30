## ALB
resource "aws_alb" "aws-ecs-dev-alb" {
  name            = "aws-ecs-dev-loadbalancer"
  subnets         = [aws_subnet.aws-dev-subnet-1.id, aws_subnet.aws-dev-subnet-2.id]
  security_groups = [aws_security_group.lb_sg.id]
  enable_http2    = "true"
  idle_timeout    = 600
}

output "alb_output" {
  value = aws_alb.aws-ecs-dev-alb.dns_name
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.aws-ecs-dev-alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.dashboard-service.id
    type             = "forward"
  }
}

resource "aws_alb_target_group" "dashboard-service" {
  name       = "dashboard-service"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.aws-dev-vpc.id
  depends_on = [aws_alb.aws-ecs-dev-alb]

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400
  }

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}
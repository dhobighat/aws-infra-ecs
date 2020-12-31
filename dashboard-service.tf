# dashboard-service
resource "aws_ecs_service" "dashboard-service" {
  name            = "dashboard-service"
  cluster         = aws_ecs_cluster.aws-dev-ecs-cluster.id
  task_definition = aws_ecs_task_definition.dashboard-service-task-definition.arn
  iam_role        = aws_iam_role.aws-dev-ecs-role.arn
  desired_count   = 2
  depends_on = [aws_iam_role_policy_attachment.aws-dev-ecs-role-attachment]

  load_balancer {
    target_group_arn = aws_alb_target_group.dashboard-service-target-group.id
    container_name   = "dashboard-service"
    container_port   = "8000"
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_ecs_task_definition" "dashboard-service-task-definition" {
  family = "dashboard-service"

  container_definitions = <<EOF
[
  {
    "portMappings": [
      {
        "hostPort": 0,
        "protocol": "tcp",
        "containerPort": 8000
      }
    ],
    "cpu": 256,
    "memory": 300,
    "image": "docker.io/docker131186/dashboard-service:latest",
    "essential": true,
    "name": "dashboard-service",
    "logConfiguration": {
    "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/aws-ecs-log/dashboard-service",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
EOF
}

resource "aws_cloudwatch_log_group" "dashboard-service-log-group" {
  name = "/aws-ecs-log/dashboard-service"
}

resource "aws_alb_target_group" "dashboard-service-target-group" {
  name       = "dashboard-service-target-group"
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.aws-dev-vpc.id
  depends_on = [aws_alb.aws-dev-alb]

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

resource "aws_alb_listener" "aws-dev-alb-listener-port-80" {
  load_balancer_arn = aws_alb.aws-dev-alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.dashboard-service-target-group.id
    type             = "forward"
  }
}
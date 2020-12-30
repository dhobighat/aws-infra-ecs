# dashboard-service
resource "aws_ecs_service" "dashboard-service" {
  name            = "dashboard-service"
  cluster         = aws_ecs_cluster.aws-ecs-dev.id
  task_definition = aws_ecs_task_definition.dashboard-service.arn
  iam_role        = aws_iam_role.ecs-service-role.arn
  desired_count   = 4
  depends_on = [aws_iam_role_policy_attachment.ecs-service-attach]

  load_balancer {
    target_group_arn = aws_alb_target_group.dashboard-service.id
    container_name   = "dashboard-service"
    container_port   = "8000"
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_ecs_task_definition" "dashboard-service" {
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

resource "aws_cloudwatch_log_group" "dashboard-service" {
  name = "/aws-ecs-log/dashboard-service"
}
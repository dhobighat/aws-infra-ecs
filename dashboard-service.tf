# dashboard-service
resource "aws_ecs_service" "dashboard-service" {
  name            = "dashboard-service"
  cluster         = aws_ecs_cluster.aws-ecs-dev.id
  task_definition = aws_ecs_task_definition.dashboard-service.arn
  desired_count   = 4
  depends_on = [aws_iam_role_policy_attachment.ecs-service-attach]

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
        "hostPort": 8000,
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
# ECS cluster
resource "aws_ecs_cluster" "aws-ecs-dev" {
  name = "aws-ecs-dev"
}
#Compute
resource "aws_autoscaling_group" "aws-ecs-dev-asg" {
  name = "aws-ecs-dev-asg"
  vpc_zone_identifier = [
  aws_subnet.aws-dev-subnet-1.id, aws_subnet.aws-dev-subnet-2.id]
  min_size                  = "1"
  max_size                  = "5"
  desired_capacity          = "1"
  launch_configuration      = aws_launch_configuration.aws-ecs-dev-cluster-lc.name
  health_check_grace_period = 120
  default_cooldown          = 30
  termination_policies      = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "aws-ecs-dev"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "aws-ecs-dev-scaling" {
  name                      = "aws-ecs-auto-scaling"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "90"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = aws_autoscaling_group.aws-ecs-dev-asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
}

resource "aws_launch_configuration" "aws-ecs-dev-cluster-lc" {
  name_prefix     = "aws-ecs-dev-cluster-lc"
  security_groups = [aws_security_group.instance_sg.id]

  image_id                    = "ami-0f06fc190dd71269e"
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.ecs-ec2-role.id
  user_data                   = data.template_file.ecs-cluster.rendered
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}
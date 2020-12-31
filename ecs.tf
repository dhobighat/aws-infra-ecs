# ECS cluster
resource "aws_ecs_cluster" "aws-dev-ecs-cluster" {
  name = "aws-dev-ecs-cluster"
}
#Compute
resource "aws_autoscaling_group" "aws-dev-asg" {
  name = "aws-dev-asg"
  vpc_zone_identifier = [
  aws_subnet.aws-dev-subnet-1.id, aws_subnet.aws-dev-subnet-2.id]
  min_size                  = "2"
  max_size                  = "5"
  desired_capacity          = "2"
  launch_configuration      = aws_launch_configuration.aws-dev-launch-config.name
  health_check_grace_period = 120
  default_cooldown          = 30
  termination_policies      = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "aws-dev-asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "aws-dev-asg-policy" {
  name                      = "aws-dev-asg-policy"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "90"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = aws_autoscaling_group.aws-dev-asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
}

resource "aws_launch_configuration" "aws-dev-launch-config" {
  name_prefix     = "aws-dev-launch-config"
  security_groups = [aws_security_group.aws-dev-ec2-sg.id]

  image_id                    = "ami-0f06fc190dd71269e"
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.aws-dev-ec2-profile.id
  user_data                   = data.template_file.ecs-cluster.rendered
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}
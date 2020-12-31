output "alb_output" {
  value = aws_alb.aws-dev-alb.dns_name
}
output "alb_output" {
  value = aws_alb.dev-alb.dns_name
}
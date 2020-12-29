variable "aws_region" {
  description = "Default AWS Region to create the resources"
  default     = "us-east-1"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}
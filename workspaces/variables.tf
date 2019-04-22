variable "aws_region" {
  description = "AWS region name"
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "The name of the AWS profile to use"
  default     = "default"
}

variable "environment" {
  description = "Environment name"
  default     = "none"
}

###############
# IAM Variables
variable "aws_region" {
  description = "AWS region for initial provider"
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Name of the AWS profile"
}

################
# Lab1 Variables
variable "script_version" {
  description = "This set the script to run.  Choose csv_read or csv_sum"
  default     = "csv_read"
}

variable "lab1_bucket_name" {
  description = "Name of the Lab1 S3 Bucket"
}

variable "lab1_role_name" {
  description = "Name of the IAM role for Lab1"
  default     = "lab1"
}

variable "lab1_role_s3_policy_name" {
  description = "Name of the IAM policy for Lab1 S3 access"
  default     = "lab1-s3-get-object"
}

variable "lab1_role_cloudwatch_policy_name" {
  description = "Name of the IAM policy for Lab1 CloudWatch Logs access"
  default     = "lab1-cloudwatch"
}

variable "lab1_lambda_function_name" {
  description = "Name of the Lambda function for Lab1"
  default     = "lab1"
}

################
# Lab2 Variables
variable "lab2_kinesis_stream_name" {
  description = "Name of the Kinesis Data Stream for Lab2"
  default     = "lab2-stream"
}

variable "lab2_role_name" {
  description = "Name of the IAM role for Lab2"
  default     = "lab2"
}

variable "lab2_role_kinesis_policy_name" {
  description = "Name of the IAM policy for Lab2 kinesis access"
  default     = "lab2-kinesis"
}

variable "lab2_role_cloudwatch_policy_name" {
  description = "Name of the IAM policy for Lab2 CloudWatch Logs access"
  default     = "lab2-cloudwatch"
}

variable "lab2_lambda_function_name" {
  description = "Name of the Lambda function for Lab2"
  default     = "lab2"
}

################
# Lab3 Variables
variable "lab3_dynamodb_table_name" {
  description = "Name of the DynamoDB table for Lab3"
  default     = "lab3-dynamodb"
}

variable "lab3_role_name" {
  description = "Name of the IAM role for Lab3"
  default     = "lab3"
}

variable "lab3_role_dynamodb_policy_name" {
  description = "Name of the IAM policy for Lab3 DynamoDB access"
  default     = "lab3-dynamodb"
}

variable "lab3_role_cloudwatch_policy_name" {
  description = "Name of the IAM policy for Lab3 CloudWatch Logs access"
  default     = "lab3-cloudwatch"
}

variable "lab3_lambda_function_name" {
  description = "Name of the Lambda function for Lab3"
  default     = "lab3"
}

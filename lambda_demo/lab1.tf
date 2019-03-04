# Select which code to run by setting the 'script_version' variable
# Making a change and re-applying will generate a new version of the Lambda function
locals {
  lambda_file    = "${var.script_version == "csv_read" ? "lab1_read.zip" : "lab1_sum.zip"}"
  lambda_handler = "${var.script_version == "csv_read" ? "csv_read.handler" : "csv_sum.handler"}"
}

# Create the S3 bucket for the lambda function
resource "aws_s3_bucket" "lab1_bucket" {
  bucket = "${var.lab1_bucket_name}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# IAM Role with S3 and CloudWatch Logs access
# Lab1 role
resource "aws_iam_role" "lab1_role" {
  name               = "${var.lab1_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.lab1_trust_policy.json}"
  description        = "Role for Lab1 Lambda"
}

# Lab1 trust policy
data "aws_iam_policy_document" "lab1_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Lab1 S3 get object policy document
data "aws_iam_policy_document" "lab1_role_s3_policy" {
  statement {
    effect    = "Allow"
    resources = ["${aws_s3_bucket.lab1_bucket.arn}/*"]
    actions   = ["s3:GetObject"]
  }
}

# Lab1 S3 get object policy
resource "aws_iam_policy" "lab1_role_s3_policy" {
  name        = "${var.lab1_role_s3_policy_name}"
  description = "This allows lambda to get objects from the ${var.lab1_bucket_name} bucket"
  policy      = "${data.aws_iam_policy_document.lab1_role_s3_policy.json}"
}

# Attach S3 policy for Lab1
resource "aws_iam_role_policy_attachment" "lab1_role_s3" {
  role       = "${aws_iam_role.lab1_role.name}"
  policy_arn = "${aws_iam_policy.lab1_role_s3_policy.arn}"
}

# Lab1 CloudWatch Logs policy document
data "aws_iam_policy_document" "lab1_role_cloudwatch_policy" {
  # statement {  #   effect    = "Allow"  #   resources = ["arn:aws:logs:${local.region-account}:*"]  #   actions   = ["logs:CreateLogGroup"]  # }

  statement {
    effect    = "Allow"
    resources = ["arn:aws:logs:${local.region-account}:log-group:/aws/lambda/${var.lab1_lambda_function_name}:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

# Lab1 CloudWatch Logs policy
resource "aws_iam_policy" "lab1_role_cloudwatch_policy" {
  name        = "${var.lab1_role_cloudwatch_policy_name}"
  description = "This allows lambda to send events to CloudWatch Logs"
  policy      = "${data.aws_iam_policy_document.lab1_role_cloudwatch_policy.json}"
}

# Attach CloudWatch Logs policy for Lab1
resource "aws_iam_role_policy_attachment" "lab1_role_cloudwatch" {
  role       = "${aws_iam_role.lab1_role.name}"
  policy_arn = "${aws_iam_policy.lab1_role_cloudwatch_policy.arn}"
}

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lab1_cloudwatch_group" {
  name              = "/aws/lambda/${aws_lambda_function.lab1_lambda.function_name}"
  retention_in_days = 14
}

# Lambda function
resource "aws_lambda_function" "lab1_lambda" {
  filename         = "files/${local.lambda_file}"
  function_name    = "${var.lab1_lambda_function_name}"
  description      = "Lamba that reads and processes a csv file from S3"
  role             = "${aws_iam_role.lab1_role.arn}"
  handler          = "${local.lambda_handler}"
  source_code_hash = "${base64sha256(file("files/${local.lambda_file}"))}"
  runtime          = "nodejs8.10"
  publish          = true
}

# Lambda S3 trigger permission
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lab1_lambda.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.lab1_bucket.arn}"
}

# Lambda S3 trigger
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "${aws_s3_bucket.lab1_bucket.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.lab1_lambda.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".csv"
  }
}

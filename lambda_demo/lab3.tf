# Create DynamoDB table
resource "aws_dynamodb_table" "lab3_dynamodb_table" {
  name             = "${var.lab3_dynamodb_table_name}"
  billing_mode     = "PROVISIONED"
  read_capacity    = 5
  write_capacity   = 5
  hash_key         = "txid"
  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"

  attribute {
    name = "txid"
    type = "S"
  }

  tags = {
    Project = "Lab3"
  }
}

# Create IAM roles and policies
# Lab3 role
resource "aws_iam_role" "lab3_role" {
  name               = "${var.lab3_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.lab3_trust_policy.json}"
  description        = "Role for Lab3 Lambda"
}

# Lab3 trust policy
data "aws_iam_policy_document" "lab3_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Lab3 DynamoDB policy document
data "aws_iam_policy_document" "lab3_role_dynamodb_policy" {
  statement {
    effect = "Allow"

    resources = [
      "arn:aws:dynamodb:${local.region-account}:table/${var.lab3_dynamodb_table_name}/stream/*",
      "arn:aws:dynamodb:*:*:table/*/index/*",
      "arn:aws:dynamodb:${local.region-account}:table/${var.lab3_dynamodb_table_name}",
    ]

    actions = [
      "dynamodb:BatchWriteItem",
      "dynamodb:PutItem",
      "dynamodb:DescribeTable",
      "dynamodb:GetShardIterator",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:DescribeStream",
      "dynamodb:GetRecords",
      "dynamodb:ListGlobalTables",
      "dynamodb:ListTables",
      "dynamodb:ListBackups",
    ]
  }
}

# Lab3 DynamoDB policy
resource "aws_iam_policy" "lab3_role_dynamodb_policy" {
  name        = "${var.lab3_role_dynamodb_policy_name}"
  description = "This allows lambda read and write data to and from DynamoDB"
  policy      = "${data.aws_iam_policy_document.lab3_role_dynamodb_policy.json}"
}

# Attach DynamoDB policy for Lab3
resource "aws_iam_role_policy_attachment" "lab3_role_dynamodb" {
  role       = "${aws_iam_role.lab3_role.name}"
  policy_arn = "${aws_iam_policy.lab3_role_dynamodb_policy.arn}"
}

# Lab3 CloudWatch Logs policy document
data "aws_iam_policy_document" "lab3_role_cloudwatch_policy" {
  statement {
    effect    = "Allow"
    resources = ["arn:aws:logs:${local.region-account}:log-group:/aws/lambda/${var.lab3_lambda_function_name}:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

# Lab3 CloudWatch Logs policy
resource "aws_iam_policy" "lab3_role_cloudwatch_policy" {
  name        = "${var.lab3_role_cloudwatch_policy_name}"
  description = "This allows lambda to send events to CloudWatch Logs"
  policy      = "${data.aws_iam_policy_document.lab3_role_cloudwatch_policy.json}"
}

# Attach CloudWatch Logs policy for Lab3
resource "aws_iam_role_policy_attachment" "lab3_role_cloudwatch" {
  role       = "${aws_iam_role.lab3_role.name}"
  policy_arn = "${aws_iam_policy.lab3_role_cloudwatch_policy.arn}"
}

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lab3_cloudwatch_group" {
  name              = "/aws/lambda/${aws_lambda_function.lab3_lambda.function_name}"
  retention_in_days = 14
}

# Create Lambda function
resource "aws_lambda_function" "lab3_lambda" {
  filename         = "files/lab3.zip"
  function_name    = "${var.lab3_lambda_function_name}"
  description      = "Lamba that interacts with DynamoDB"
  role             = "${aws_iam_role.lab3_role.arn}"
  handler          = "index.handler"
  source_code_hash = "${base64sha256(file("files/lab3.zip"))}"
  runtime          = "nodejs8.10"

  environment {
    variables = {
      TABLE = "${var.lab3_dynamodb_table_name}"
    }
  }
}

# Create trigger from DynamoDB
resource "aws_lambda_event_source_mapping" "lab3_dynamodb_lambda_event_mapping" {
  event_source_arn  = "${aws_dynamodb_table.lab3_dynamodb_table.stream_arn}"
  function_name     = "${aws_lambda_function.lab3_lambda.arn}"
  starting_position = "LATEST"
}

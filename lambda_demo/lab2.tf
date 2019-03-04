# Create Kinesis Data Stream
resource "aws_kinesis_stream" "lab2_kinesis_stream" {
  name             = "${var.lab2_kinesis_stream_name}"
  shard_count      = 1
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  tags = {
    Project = "Lab2"
  }
}

# Create IAM roles and policies
# Lab2 role
resource "aws_iam_role" "lab2_role" {
  name               = "${var.lab2_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.lab2_trust_policy.json}"
  description        = "Role for Lab2 Lambda"
}

# Lab2 trust policy
data "aws_iam_policy_document" "lab2_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Lab2 kinesis policy document
data "aws_iam_policy_document" "lab2_role_kinesis_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "kinesis:DescribeStream",
      "kinesis:DescribeStreamSummary",
      "kinesis:GetRecords",
      "kinesis:GetShardIterator",
      "kinesis:ListShards",
      "kinesis:ListStreams",
      "kinesis:SubscribeToShard",
    ]
  }
}

# Lab2 kinesis policy
resource "aws_iam_policy" "lab2_role_kinesis_policy" {
  name        = "${var.lab2_role_kinesis_policy_name}"
  description = "This allows lambda to get objects from the Kinesis Data Stream"
  policy      = "${data.aws_iam_policy_document.lab2_role_kinesis_policy.json}"
}

# Attach Kinesis policy for Lab2
resource "aws_iam_role_policy_attachment" "lab2_role_kinesis" {
  role       = "${aws_iam_role.lab2_role.name}"
  policy_arn = "${aws_iam_policy.lab2_role_kinesis_policy.arn}"
}

# Lab2 CloudWatch Logs policy document
data "aws_iam_policy_document" "lab2_role_cloudwatch_policy" {
  statement {
    effect    = "Allow"
    resources = ["arn:aws:logs:${local.region-account}:log-group:/aws/lambda/${var.lab2_lambda_function_name}:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

# Lab2 CloudWatch Logs policy
resource "aws_iam_policy" "lab2_role_cloudwatch_policy" {
  name        = "${var.lab2_role_cloudwatch_policy_name}"
  description = "This allows lambda to send events to CloudWatch Logs"
  policy      = "${data.aws_iam_policy_document.lab2_role_cloudwatch_policy.json}"
}

# Attach CloudWatch Logs policy for Lab2
resource "aws_iam_role_policy_attachment" "lab2_role_cloudwatch" {
  role       = "${aws_iam_role.lab2_role.name}"
  policy_arn = "${aws_iam_policy.lab2_role_cloudwatch_policy.arn}"
}

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lab2_cloudwatch_group" {
  name              = "/aws/lambda/${aws_lambda_function.lab2_lambda.function_name}"
  retention_in_days = 14
}

# Create Lambda function
resource "aws_lambda_function" "lab2_lambda" {
  filename         = "files/lab2.zip"
  function_name    = "${var.lab2_lambda_function_name}"
  description      = "Lamba that reads from a Kinesis Data Stream"
  role             = "${aws_iam_role.lab2_role.arn}"
  handler          = "index.handler"
  source_code_hash = "${base64sha256(file("files/lab2.zip"))}"
  runtime          = "nodejs8.10"
}

# Create trigger from Kinesis
resource "aws_lambda_event_source_mapping" "lab2_kineis_lambda_event_mapping" {
  event_source_arn  = "${aws_kinesis_stream.lab2_kinesis_stream.arn}"
  function_name     = "${aws_lambda_function.lab2_lambda.arn}"
  starting_position = "LATEST"
}

# Connect to AWS with the specified profile credentials
provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

# Get the access to the effective Account ID in which Terraform is working.
data "aws_caller_identity" "current" {}

# Set local variables
locals {
  region-account = "${var.aws_region}:${data.aws_caller_identity.current.account_id}"
}

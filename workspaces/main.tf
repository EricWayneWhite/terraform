provider "aws" {
  region  = "${local.aws_region}"
  profile = "${var.aws_profile}"
}

locals {
  # Expects named terraform workspaces in the format <environment>_<aws region>
  # A default workspace will use the values from variables
  workspace = ["${split("_", "${terraform.workspace}")}"]

  environment = "${terraform.workspace == "default" ? var.environment : element(local.workspace, 0)}"
  aws_region  = "${terraform.workspace == "default" ? var.aws_region : element(local.workspace, 1)}"
}

resource "random_id" "random" {
  byte_length = 8
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "tf-workspaces-${local.environment}-${random_id.random.hex}"
  acl    = "private"

  tags = {
    Environment = "${local.environment}"
  }
}

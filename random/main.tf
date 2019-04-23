variable "ami_id" {
  description = "Reference to an AMI ID that, when changed, will trigger a new random ID when included in the keepers section"
  default     = "ami-061392db613a6357b"
}

resource "random_id" "random" {
  byte_length = 8

  keepers = {
    # Generate a new id each time we switch to a new AMI id
    ami_id = "${var.ami_id}"
  }
}

resource "random_integer" "random" {
  min = 1
  max = 500
}

resource "random_pet" "random" {}

resource "random_shuffle" "random" {
  input = ["us-west-1a", "us-west-1b", "us-west-1c"]

  # Optional count, otherwise all items returned
  result_count = 2
}

resource "random_string" "random" {
  length           = 20
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  special          = true
  override_special = "!@#$%&*()=+?"
}

resource "random_uuid" "random" {}

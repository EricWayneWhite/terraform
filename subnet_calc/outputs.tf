output "cidr_primary" {
  description = "This is the CIDR block provided for the primary VPC"
  value       = "${var.cidr_primary}"
}

output "cidr_secondary" {
  description = "This is the CIDR block provided for the secondary VPC"
  value       = "${var.cidr_secondary}"
}

output "private_subnets_primary" {
  description = "This returns a list of private subnets for the primary VPC"
  value       = "${local.private_subnets_primary}"
}

output "private_subnets_secondary" {
  description = "This returns a list of private subnets for the secondary VPC"
  value       = "${local.private_subnets_secondary}"
}

output "public_subnets_primary" {
  description = "This returns a list of public subnets for the primary VPC"
  value       = "${local.public_subnets_primary}"
}

output "public_subnets_secondary" {
  description = "This returns a list of public subnets for the secondary VPC"
  value       = "${local.public_subnets_secondary}"
}

output "spare_primary_cidr" {
  description = "This is the spare subnet for the primary VPC"
  value       = "${local.spare_primary_cidr}"
}

output "spare_secondary_cidr" {
  description = "This is the spare subnet for the secondary VPC"
  value       = "${local.spare_secondary_cidr}"
}

output "random_id" {
  description = "Random ID"
  value       = "${random_id.random.hex}"
}

output "random_integer" {
  description = "Random Integer"
  value       = "${random_integer.random.result}"
}

output "random_pet" {
  description = "Random Pet"
  value       = "${random_pet.random.id}"
}

output "random_shuffle" {
  description = "Random Shuffle"
  value       = "${random_shuffle.random.result}"
}

output "random_string" {
  description = "Random String"
  value       = "${random_string.random.result}"
}

output "random_uuid" {
  description = "Random UUID"
  value       = "${random_uuid.random.result}"
}

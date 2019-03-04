# Lab1
output "lab1_lambda_script_version" {
  description = "Version of the script run by the lambda"
  value       = "${var.script_version}"
}

output "lab1_lambda_latest_version" {
  description = "Version of the Lab1 lambda"
  value       = "${aws_lambda_function.lab1_lambda.version}"
}

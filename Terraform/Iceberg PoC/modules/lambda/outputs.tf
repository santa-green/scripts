output "lambda_arn" {
  description = "Lambda ARN"
  value       = [for l in aws_lambda_function.this : l.arn]
}

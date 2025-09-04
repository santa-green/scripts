variable "lambda_function" {
  description = "Lambda function"
  type        = any
}

variable "lambda_policy_arns" {
  description = "Lambda policy arns"
  type        = list(string)
}

variable "lambda_permissions_source_arn" {
  description = "Source ARN that triggers lambda"
  type        = any
}

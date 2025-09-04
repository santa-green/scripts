output "aws_iam_roles_arn" {
  description = "ARNs of the IAM roles"
  value       = { for k, iar in aws_iam_role.this : k => iar.arn }
}

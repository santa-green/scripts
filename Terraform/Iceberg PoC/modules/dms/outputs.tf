output "dms_iam_s3_role_arn" {
  description = "The ARN of the DMS to access S3"
  value       = aws_iam_role.dms_s3_access_role.arn
}

output "dms_iam_secrets_role_arn" {
  description = "The ARN of the DMS to access secrets manager"
  value       = aws_iam_role.dms_secrets_role.arn
}

output "dms_iam_vpc_role_arn" {
  description = "The ARN of the DMS to access VPC"
  value       = aws_iam_role.dms-vpc-role.arn
}

output "aws_dms_replication_subnet_group_vpc" {
  description = "The ID of the DMS replication subnet group VPC id"
  value       = aws_dms_replication_subnet_group.this.vpc_id
}

output "aws_dms_replication_instance_arn" {
  description = "ARN of the DMS replication instance"
  value       = aws_dms_replication_instance.this_instance.replication_instance_arn
}

output "aws_dms_replication_instance_ips" {
  description = "IP of the DMS replication instance"
  value       = aws_dms_replication_instance.this_instance.replication_instance_private_ips
}

output "aws_dms_endpoint_arns" {
  description = "ARNs of the DMS endpoints"
  value       = [for ep in aws_dms_endpoint.endpoint_this : ep.endpoint_arn]
}

output "aws_dms_s3_endpoint_arns" {
  description = "ARNs of the DMS S3 endpoints"
  value       = [for ep in aws_dms_s3_endpoint.endpoint_this : ep.endpoint_arn]
}

output "aws_dms_replication_tasks_arns" {
  description = "ARNs of the DMS tasks"
  value       = [for ep in aws_dms_replication_task.this : ep.replication_task_arn]
}

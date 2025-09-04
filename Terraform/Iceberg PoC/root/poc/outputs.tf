output "dms_iam_s3_role_arn" {
  description = "The ARN of the DMS to access S3"
  value       = module.dms.dms_iam_s3_role_arn
}

output "dms_iam_secrets_role_arn" {
  description = "The ARN of the DMS to access secrets manager"
  value       = module.dms.dms_iam_secrets_role_arn
}

output "dms_iam_vpc_role_arn" {
  description = "The ARN of the DMS to access VPC"
  value       = module.dms.dms_iam_vpc_role_arn
}

output "dms_replication_subnet_group_vpc" {
  description = "The ID of the DMS replication subnet group VPC id"
  value       = module.dms.aws_dms_replication_subnet_group_vpc
}

output "dms_replication_instance_arn" {
  description = "ARN of the DMS replication instance"
  value       = module.dms.aws_dms_replication_instance_arn
}

output "dms_replication_instance_ips" {
  description = "IP of the DMS replication instance"
  value       = module.dms.aws_dms_replication_instance_ips
}

output "dms_endpoint_arns" {
  description = "ARNs of the DMS endpoints"
  value       = module.dms.aws_dms_endpoint_arns
}

output "dms_s3_endpoint_arns" {
  description = "ARNs of the DMS S3 endpoints"
  value       = module.dms.aws_dms_s3_endpoint_arns
}

output "dms_replication_tasks_arns" {
  description = "ARNs of the DMS tasks"
  value       = module.dms.aws_dms_replication_tasks_arns
}


output "iam_roles_arn" {
  description = "ARNs of the IAM roles"
  value       = module.iam.aws_iam_roles_arn
}

output "redhshift_cluster_arn" {
  description = "The Redshift cluster ARN"
  value       = module.redshift.cluster_arn
}

output "redhshift_cluster_id" {
  description = "The Redshift cluster ID"
  value       = module.redshift.cluster_id
}

output "redhshift_cluster_identifier" {
  description = "The Redshift cluster identifier"
  value       = module.redshift.cluster_identifier
}

output "redhshift_cluster_type" {
  description = "The Redshift cluster type"
  value       = module.redshift.cluster_type
}

output "redhshift_cluster_node_type" {
  description = "The type of nodes in the cluster"
  value       = module.redshift.cluster_node_type
}

output "redhshift_cluster_database_name" {
  description = "The name of the default database in the Cluster"
  value       = module.redshift.cluster_database_name
}

output "s3_bucket_id" {
  description = "The name of the bucket."
  value       = [for s in module.s3_bucket : s.s3_bucket_id]
}

output "s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = [for s in module.s3_bucket : s.s3_bucket_arn]
}


output "redshift_security_group_arn" {
  description = "The ARN of the security group"
  value       = module.redshift_sg.security_group_arn
}

output "redshift_security_group_id" {
  description = "The ID of the security group"
  value       = module.redshift_sg.security_group_id
}

output "redshift_security_group_vpc_id" {
  description = "The VPC ID"
  value       = module.redshift_sg.security_group_vpc_id
}


output "eventbdrige_rule_id" {
  description = "Eventbrdige Rule ID"
  value       = module.eventbridge.rule_arns
}

output "lambda_ARN" {
  description = "Lambda function ARNs"
  value       = module.lambda.lambda_arn
}

output "secret_ID" {
  description = "Secrets ID's"
  value       = module.secrets.secret_id
}

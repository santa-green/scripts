variable "vpc_name" {
  description = "VPC name"
  type        = string
}
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "vpc_azs" {
  description = "VPC AZs to deploy"
  type        = list(string)
}
variable "vpc_private_subnets" {
  description = "VPC Private subnet CIDR"
  type        = list(string)
}
variable "vpc_public_subnets" {
  description = "VPC Public subnet CIDR"
  type        = list(string)
}

variable "vpc_default_sg_id" {
  description = "default VPC security group"
  type        = string
}

variable "manage_default_network_acl" {
  description = "Default network ACL"
  type        = bool
  default     = false
}

variable "vpc_enable_nat_gateway" {
  description = "VPC Enable NAT gateway"
  type        = bool
  default     = true
}
variable "vpc_enable_vpn_gateway" {
  description = "VPC Enable VPN gatway"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "private_subnets_ids" {
  description = "Private subnets IDs"
  type        = list(string)
  default     = [""]
}

variable "sg_redshift_name" {
  description = "security group name"
  type        = string
  default     = ""
}

variable "sg_redshift_description" {
  description = "Security group desciption"
  type        = string
  default     = ""
}

variable "s3_buckets" {
  type = map(object({
    acl                      = string
    control_object_ownership = bool
    object_ownership         = string
    versioning = optional(object({
      enabled = string
    }))
  }))
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "redshift_cluster_idnetifier" {
  description = "Redshift cluster idnetifier"
  type        = string
  default     = ""
}

variable "redshift_allow_version_upgrade" {
  description = "Allow Redshift version upgrade"
  type        = bool
  default     = true
}
variable "redshift_node_type" {
  description = "Redshift node type"
  type        = string
  default     = "ra3.large"
}
variable "redshift_number_of_nodes" {
  description = "Number of Redshift nodes"
  type        = string
  default     = "1"
}
variable "database_name" {
  description = "Redshift DB name"
  type        = string
  default     = "RSDB"
}
variable "master_username" {
  description = "Redshift master username"
  type        = string
  default     = "admin"
}
variable "create_random_password" {
  description = "Create random password"
  type        = bool
  default     = false
}
/*variable "master_password" {
  description = "Master password"
  type        = string
  default     = ""
}*/
variable "manage_master_password" {
  description = "manager master password with secrets manager"
  type        = bool
  default     = true
}
variable "encrypted" {
  description = "Enable encryption"
  type        = bool
  default     = false
}
variable "kms_key_arn" {
  description = "KMS key ARN"
  type        = string
  default     = ""
}
variable "enhanced_vpc_routing" {
  description = "Enhanced VPC routing"
  type        = bool
  default     = true
}
variable "vpc_security_group_ids" {
  description = "VPC security groups IDs"
  type        = list(string)
  default     = [""]
}
variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
  default     = [""]
}
variable "availability_zone_relocation_enabled" {
  description = "Availability zone replication"
  type        = bool
  default     = false
}
variable "snapshot_copy" {
  description = "Snapshot copy"
  type        = map(string)
}
variable "parameter_group_name" {
  description = "Redshift parameter group name"
  type        = string
  default     = ""
}
variable "parameter_group_description" {
  description = "Parameter group description"
  type        = string
  default     = ""
}
variable "parameter_group_parameters" {
  description = "Parameter group parameters"
  type = map(object({
    name  = string
    value = any
  }))
}
variable "parameter_group_tags" {
  description = "Parameter group tags"
  type        = map(string)
}
variable "subnet_group_name" {
  description = "Subnet group name"
  type        = string
  default     = ""
}
variable "subnet_group_description" {
  description = "Subnet group description"
  type        = string
  default     = ""
}
variable "subnet_group_tags" {
  description = "Subnet group tags"
  type        = map(string)
}
variable "create_snapshot_schedule" {
  description = "Create snapshod schedule"
  type        = bool
  default     = true
}
variable "snapshot_schedule_identifier" {
  description = "Snapshot schedule identifier"
  type        = string
  default     = ""
}
variable "use_snapshot_identifier_prefix" {
  description = "Use snapshot identifier prefix"
  type        = bool
  default     = true
}
variable "snapshot_schedule_description" {
  description = "Snapshot schedule description"
  type        = string
  default     = ""
}
variable "snapshot_schedule_definitions" {
  description = "Snapshot schedule definition"
  type        = list(string)
  default     = [""]
}
variable "snapshot_schedule_force_destroy" {
  description = "Snapshot schedule force destroy"
  type        = bool
  default     = true
}
variable "create_scheduled_action_iam_role" {
  description = "Create schedule action IAM role"
  type        = bool
  default     = true
}

variable "scheduled_actions" {
  description = "Redshift scheduled actions"
  type        = any
}
variable "create_endpoint_access" {
  description = "Create endpoint access"
  type        = bool
  default     = true
}
variable "endpoint_name" {
  description = "Endpoint name"
  type        = string
  default     = ""
}

variable "endpoint_subnet_group_name" {
  description = "Endpoint subnet group name"
  type        = string
  default     = ""
}
variable "endpoint_vpc_security_group_ids" {
  description = "Endpoint VPC Security group IDs"
  type        = list(string)
  default     = [""]
}
variable "usage_limits" {
  type = map(object({
    feature_type  = string
    limit_type    = string
    amount        = string
    breach_action = string
    tags          = optional(map(any))
  }))
}

variable "replication_subnet_group_description" {
  description = "Replication subnet group description"
  type        = string
  default     = ""
}
variable "replication_subnet_group_id" {
  description = "Replication subnet group ID"
  type        = string
  default     = ""
}

variable "replication_instance_id" {
  description = "Replication instance ID"
  type        = string
  default     = ""
}
variable "replication_instance_class" {
  description = "Replication instance class"
  type        = string
  default     = ""
}
variable "allocated_storage" {
  description = "Allocalted storage"
  type        = string
  default     = ""
}
variable "apply_immediately" {
  description = "Apply immediately"
  type        = bool
  default     = true
}
variable "publicly_accessible" {
  description = "Public accessible"
  type        = bool
  default     = false
}
variable "dms_endpoints" {
  description = "DMS endpoint configurations"
  type        = any
}

variable "dms_s3_enpoints" {
  description = "DMS S3 endpoints configuratuins"
  type        = any
}

variable "dms_task" {
  description = "DMS replication tasks configuratiuns"
  type        = any
}

variable "sqlserver_secrets_arn" {
  description = "Secrets manager ARN with sql server parameters"
  type        = string
  default     = ""
}

variable "iam_roles" {
  description = "IAM roles"
  type        = any
}

variable "glue_job" {
  description = "Glue Job"
  type        = any
}

variable "glue_connection" {
  description = "Glue Connections"
  type        = map(any)
}

variable "lambda_function" {
  description = "Lambda function"
  type        = any
}

variable "lambda_policy_arns" {
  description = "Lambda policy arns"
  type        = list(string)
}

variable "eventbrdige_rules" {
  description = "Eventbridge rule"
  type        = any
}

variable "eventbridge_target" {
  description = "Eventbridge targets"
  type        = any
}

variable "eventbridge_role_arn" {
  description = "Eventbrge role ARN"
  type        = string
}

variable "eventbridge_policy_arns" {
  description = "policy arns for eventbridge role"
  type        = list(string)
  default     = [""]
}

variable "tags" {
  description = "Tags"
  type        = map(string)
}

variable "secrets" {
  description = "Secrets"
  type        = map(any)
}

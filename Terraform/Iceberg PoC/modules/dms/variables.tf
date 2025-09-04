variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = ""
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
variable "subnet_ids" {
  description = " Subnet IDs"
  type        = list(string)
}

variable "sqlserver_secrets_arn" {
  description = "Secrets manager for sql server"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags"
  type        = map(string)
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

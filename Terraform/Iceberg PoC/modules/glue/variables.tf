variable "glue_job" {
  description = "Glue Job"
  type        = any
}

variable "glue_job_role" {
  description = "Glue job IAM role"
  type        = map(string)
}

variable "glue_connection" {
  description = "Glue connection"
  type        = map(any)
}

variable "vpc_azs" {
  description = "VPC AZs"
  type        = string
}

variable "glue_sg" {
  description = "Glue Security groups"
  type        = string
}

variable "vpc_private_subnets" {
  description = "value"
  type        = string
}

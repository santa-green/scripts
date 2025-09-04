variable "eventbrdige_rules" {
  description = "Eventbridge rule"
  type        = any
}

variable "eventbridge_target" {
  description = "Eventbridge targets"
  type        = any
}

variable "event_target_arn" {
  description = "Event target ARN"
  type        = list(string)
}

variable "eventbridge_role_arn" {
  description = "Eventbriduge role ARN"
  type        = string
}

variable "policy_arns" {
  description = "policy arns for role"
  type        = list(string)
}

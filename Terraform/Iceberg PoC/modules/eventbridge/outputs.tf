output "rule_arns" {
  value = aws_cloudwatch_event_rule.this["trigger_hcm_cdc_test"].arn
}

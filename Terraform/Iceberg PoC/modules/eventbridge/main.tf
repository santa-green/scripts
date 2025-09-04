resource "aws_iam_role" "this" {
  name = "Amazon_EventBridge_Invoke_HCM_CDC_Glue"
  path = "/service-role/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Sid    = "TrustEventBridgeService"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceArn"     = "arn:aws:events:us-east-1:370519913792:rule/trigger_hcm_cdc_test"
            "aws:SourceAccount" = "370519913792"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = toset(var.policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline" {
  name = "eventbridge-glue-policy"
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "VisualEditor0"
        Effect   = "Allow"
        Action   = "glue:NotifyEvent"
        Resource = "arn:aws:glue:us-east-1:370519913792:workflow/hcm_cdc_workflow"
      },
      {
        Effect   = "Allow"
        Action   = "glue:StartWorkflowRun"
        Resource = "arn:aws:glue:us-east-1:370519913792:workflow/hcm_cdc_workflow"
      }
    ]
  })
}

resource "aws_cloudwatch_event_rule" "this" {
  for_each = var.eventbrdige_rules

  name          = each.key
  description   = each.value.desciption
  event_pattern = each.value.event_pattern
}

resource "aws_cloudwatch_event_target" "this" {
  for_each  = { for idx, arn in var.event_target_arn : idx => arn }
  rule      = aws_cloudwatch_event_rule.this[var.eventbridge_target.rule_id].name
  target_id = var.eventbridge_target.target_id
  arn       = each.value
  #  role_arn  = var.eventbridge_role_arn
  role_arn = aws_iam_role.this.arn
  dynamic "input_transformer" {
    for_each = try(var.eventbridge_target.input_transformer != null ? [var.eventbridge_target.input_transformer] : [], [])
    content {
      input_paths    = input_transformer.value.input_paths
      input_template = jsonencode(input_transformer.value.input_template)
    }
  }
}


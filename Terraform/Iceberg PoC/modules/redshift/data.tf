data "aws_partition" "current" {}

data "aws_iam_policy_document" "scheduled_action_assume" {
  count = var.create && var.create_scheduled_action_iam_role ? 1 : 0

  statement {
    sid     = "ScheduleActionAssume"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["scheduler.redshift.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

data "aws_iam_policy_document" "scheduled_action" {
  count = var.create && var.create_scheduled_action_iam_role ? 1 : 0

  statement {
    sid = "ModifyCluster"

    actions = [
      "redshift:PauseCluster",
      "redshift:ResumeCluster",
      "redshift:ResizeCluster",
    ]

    resources = [
      aws_redshift_cluster.this[0].arn
    ]
  }
}
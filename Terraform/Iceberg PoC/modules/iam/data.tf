data "aws_iam_policy" "policies" {
  for_each = toset(flatten([
    for role in var.iam_roles : role.policy_names
  ]))
  name = each.key
}


resource "aws_iam_role" "this" {
  for_each              = var.iam_roles
  name                  = each.key
  description           = each.value.description
  force_detach_policies = each.value.force_detach_policies
  assume_role_policy    = each.value.assume_role_policy
  tags                  = each.value.tags
}

resource "aws_iam_role_policy_attachment" "attach" {
  for_each = {
    for attachment in flatten([
      for role_name, role_data in var.iam_roles : [
        for policy_names in role_data.policy_names : {
          role_name    = role_name
          policy_names = policy_names
        }
      ]
    ]) : "${attachment.role_name}-${attachment.policy_names}" => attachment
  }
  role       = aws_iam_role.this[each.value.role_name].name
  policy_arn = data.aws_iam_policy.policies[each.value.policy_names].arn

}



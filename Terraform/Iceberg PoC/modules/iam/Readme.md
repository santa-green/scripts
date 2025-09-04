<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy.policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_iam_roles"></a> [iam\_roles](#input\_iam\_roles) | IAM roles and policies | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_iam_roles_arn"></a> [aws\_iam\_roles\_arn](#output\_aws\_iam\_roles\_arn) | ARNs of the IAM roles |
| <a name="output_aws_iam_roles_id"></a> [aws\_iam\_roles\_id](#output\_aws\_iam\_roles\_id) | Friendly nam of the IAM roles |
<!-- END_TF_DOCS -->
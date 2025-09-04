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
| [aws_dms_endpoint.endpoint_this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_endpoint) | resource |
| [aws_dms_replication_instance.this_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_instance) | resource |
| [aws_dms_replication_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_subnet_group) | resource |
| [aws_dms_replication_task.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_replication_task) | resource |
| [aws_dms_s3_endpoint.endpoint_this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dms_s3_endpoint) | resource |
| [aws_iam_role.dms-vpc-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.dms_s3_access_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.dms_secrets_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.dms_secrets_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.dms-vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.dms_s3_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | Allocalted storage | `string` | `""` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Apply immediately | `bool` | `true` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region | `string` | `""` | no |
| <a name="input_dms_endpoints"></a> [dms\_endpoints](#input\_dms\_endpoints) | DMS endpoint configurations | `any` | n/a | yes |
| <a name="input_dms_s3_enpoints"></a> [dms\_s3\_enpoints](#input\_dms\_s3\_enpoints) | DMS S3 endpoints configuratuins | `any` | n/a | yes |
| <a name="input_dms_task"></a> [dms\_task](#input\_dms\_task) | DMS replication tasks configuratiuns | `any` | n/a | yes |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Public accessible | `bool` | `false` | no |
| <a name="input_replication_instance_class"></a> [replication\_instance\_class](#input\_replication\_instance\_class) | Replication instance class | `string` | `""` | no |
| <a name="input_replication_instance_id"></a> [replication\_instance\_id](#input\_replication\_instance\_id) | Replication instance ID | `string` | `""` | no |
| <a name="input_replication_subnet_group_description"></a> [replication\_subnet\_group\_description](#input\_replication\_subnet\_group\_description) | Replication subnet group description | `string` | `""` | no |
| <a name="input_replication_subnet_group_id"></a> [replication\_subnet\_group\_id](#input\_replication\_subnet\_group\_id) | Replication subnet group ID | `string` | `""` | no |
| <a name="input_sqlserver_secrets_arn"></a> [sqlserver\_secrets\_arn](#input\_sqlserver\_secrets\_arn) | Secrets manager for sql server | `string` | `""` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_dms_endpoint_arns"></a> [aws\_dms\_endpoint\_arns](#output\_aws\_dms\_endpoint\_arns) | ARNs of the DMS endpoints |
| <a name="output_aws_dms_replication_instance_arn"></a> [aws\_dms\_replication\_instance\_arn](#output\_aws\_dms\_replication\_instance\_arn) | ARN of the DMS replication instance |
| <a name="output_aws_dms_replication_instance_ips"></a> [aws\_dms\_replication\_instance\_ips](#output\_aws\_dms\_replication\_instance\_ips) | IP of the DMS replication instance |
| <a name="output_aws_dms_replication_subnet_group_vpc"></a> [aws\_dms\_replication\_subnet\_group\_vpc](#output\_aws\_dms\_replication\_subnet\_group\_vpc) | The ID of the DMS replication subnet group VPC id |
| <a name="output_aws_dms_replication_tasks_arns"></a> [aws\_dms\_replication\_tasks\_arns](#output\_aws\_dms\_replication\_tasks\_arns) | ARNs of the DMS tasks |
| <a name="output_aws_dms_s3_endpoint_arns"></a> [aws\_dms\_s3\_endpoint\_arns](#output\_aws\_dms\_s3\_endpoint\_arns) | ARNs of the DMS S3 endpoints |
| <a name="output_dms_iam_s3_role_arn"></a> [dms\_iam\_s3\_role\_arn](#output\_dms\_iam\_s3\_role\_arn) | The ARN of the DMS to access S3 |
| <a name="output_dms_iam_secrets_role_arn"></a> [dms\_iam\_secrets\_role\_arn](#output\_dms\_iam\_secrets\_role\_arn) | The ARN of the DMS to access secrets manager |
| <a name="output_dms_iam_vpc_role_arn"></a> [dms\_iam\_vpc\_role\_arn](#output\_dms\_iam\_vpc\_role\_arn) | The ARN of the DMS to access VPC |
<!-- END_TF_DOCS -->
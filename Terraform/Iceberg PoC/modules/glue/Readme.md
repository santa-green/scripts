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
| [aws_glue_job.etl_job](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_job) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_glue_job"></a> [glue\_job](#input\_glue\_job) | Glue Job | `any` | n/a | yes |
| <a name="input_glue_job_role"></a> [glue\_job\_role](#input\_glue\_job\_role) | Glue job IAM role | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
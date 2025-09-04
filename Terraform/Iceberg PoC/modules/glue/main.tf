resource "aws_glue_job" "etl_job" {
  for_each = var.glue_job

  name              = each.key
  description       = each.value.description
  role_arn          = var.glue_job_role[each.value.iam_role_name]
  glue_version      = each.value.glue_version
  max_retries       = each.value.max_retries
  timeout           = each.value.timeout
  number_of_workers = each.value.number_of_workers
  worker_type       = each.value.worker_type
  execution_class   = each.value.execution_class

  dynamic "command" {
    for_each = try(each.value.command != null ? [each.value.command] : [], [])
    content {
      script_location = command.value.script_location
      name            = command.value.name
      python_version  = command.value.python_version
    }
  }

  default_arguments = try(each.value.default_arguments, null)

  dynamic "execution_property" {
    for_each = try(each.value.execution_property != null ? [each.value.execution_property] : [], [])
    content {
      max_concurrent_runs = execution_property.value.max_concurrent_runs

    }
  }

  job_run_queuing_enabled = true

  tags = each.value.tags
}

resource "aws_glue_connection" "this" {
  for_each = var.glue_connection

  name = each.key
  connection_properties = {
    JDBC_CONNECTION_URL = "jdbc:${each.value.dbtype}://${each.value.srcdb};databaseName=${each.value.srcdbname}"
    SECRET_ID           = each.value.secret_arn
  }
  physical_connection_requirements {
    availability_zone      = var.vpc_azs
    security_group_id_list = [var.glue_sg]
    subnet_id              = var.vpc_private_subnets
  }
}

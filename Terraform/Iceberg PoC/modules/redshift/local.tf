locals {
  subnet_group_name    = var.create && var.create_subnet_group ? aws_redshift_subnet_group.this[0].name : var.subnet_group_name
  parameter_group_name = var.create && var.create_parameter_group ? aws_redshift_parameter_group.this[0].id : var.parameter_group_name

  master_password = var.create && var.create_random_password ? random_password.master_password[0].result : var.master_password

  iam_role_name = coalesce(var.iam_role_name, "${var.cluster_identifier}-scheduled-action")
}


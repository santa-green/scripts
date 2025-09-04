module "s3_bucket" {
  source   = "../../modules/s3"
  for_each = var.s3_buckets

  bucket                   = each.key
  acl                      = each.value.acl
  control_object_ownership = each.value.control_object_ownership
  object_ownership         = each.value.object_ownership
  versioning               = each.value.versioning
}

module "redshift_sg" {
  source = "../../modules/sg/redshift"

  name        = var.sg_redshift_name
  description = var.sg_redshift_description
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = [var.vpc_cidr_block]
}

module "redshift" {
  source = "../../modules/redshift"

  cluster_identifier     = var.redshift_cluster_idnetifier
  allow_version_upgrade  = var.redshift_allow_version_upgrade
  node_type              = var.redshift_node_type
  number_of_nodes        = var.redshift_number_of_nodes
  database_name          = var.database_name
  master_username        = var.master_username
  create_random_password = var.create_random_password
  #  master_password        = var.master_password
  manage_master_password = var.manage_master_password
  encrypted              = var.encrypted
  kms_key_arn            = var.kms_key_arn

  enhanced_vpc_routing   = var.enhanced_vpc_routing
  vpc_security_group_ids = [module.redshift_sg.security_group_id]
  subnet_ids             = var.private_subnets_ids

  availability_zone_relocation_enabled = var.availability_zone_relocation_enabled
  #  snapshot_copy                        = var.snapshot_copy

  # Parameter group
  parameter_group_name        = var.parameter_group_name
  parameter_group_description = var.parameter_group_description
  parameter_group_parameters  = var.parameter_group_parameters
  parameter_group_tags        = var.parameter_group_tags

  # Subnet group
  subnet_group_name        = var.subnet_group_name
  subnet_group_description = var.subnet_group_description
  subnet_group_tags        = var.subnet_group_tags

  # Snapshot schedule
  create_snapshot_schedule        = var.create_snapshot_schedule
  snapshot_schedule_identifier    = var.snapshot_schedule_identifier
  use_snapshot_identifier_prefix  = var.use_snapshot_identifier_prefix
  snapshot_schedule_description   = var.snapshot_schedule_description
  snapshot_schedule_definitions   = var.snapshot_schedule_definitions
  snapshot_schedule_force_destroy = var.snapshot_schedule_force_destroy

  # Scheduled actions
  create_scheduled_action_iam_role = var.create_scheduled_action_iam_role
  scheduled_actions                = var.scheduled_actions
  # Endpoint access
  create_endpoint_access          = var.create_endpoint_access
  endpoint_name                   = var.endpoint_name
  endpoint_subnet_group_name      = var.endpoint_subnet_group_name
  endpoint_vpc_security_group_ids = [module.redshift_sg.security_group_id]

  # Usage limits
  usage_limits = var.usage_limits

  tags = var.tags
}


module "dms" {
  source                               = "../../modules/dms"
  aws_region                           = var.aws_region
  replication_subnet_group_description = var.replication_subnet_group_description
  replication_subnet_group_id          = var.replication_subnet_group_id
  subnet_ids                           = var.private_subnets_ids
  sqlserver_secrets_arn                = var.sqlserver_secrets_arn

  replication_instance_id    = var.replication_instance_id
  replication_instance_class = var.replication_instance_class
  allocated_storage          = var.allocated_storage
  apply_immediately          = var.apply_immediately
  publicly_accessible        = var.publicly_accessible

  dms_endpoints   = var.dms_endpoints
  dms_s3_enpoints = var.dms_s3_enpoints
  dms_task        = var.dms_task
  tags            = var.tags

}

module "iam" {
  source = "../../modules/iam"

  iam_roles = var.iam_roles
}

module "glue" {
  source = "../../modules/glue"

  glue_job            = var.glue_job
  glue_job_role       = module.iam.aws_iam_roles_arn
  glue_connection     = var.glue_connection
  vpc_azs             = var.vpc_azs[0]
  glue_sg             = var.vpc_default_sg_id
  vpc_private_subnets = var.private_subnets_ids[0]
}

module "lambda" {
  source = "../../modules/lambda"

  lambda_function               = var.lambda_function
  lambda_policy_arns            = var.lambda_policy_arns
  lambda_permissions_source_arn = module.eventbridge.rule_arns
}

module "eventbridge" {
  source = "../../modules/eventbridge"

  eventbrdige_rules    = var.eventbrdige_rules
  eventbridge_target   = var.eventbridge_target
  event_target_arn     = module.lambda.lambda_arn
  eventbridge_role_arn = var.eventbridge_role_arn
  policy_arns          = var.eventbridge_policy_arns
}

module "secrets" {
  source = "../../modules/secrets"

  secrets = var.secrets
}

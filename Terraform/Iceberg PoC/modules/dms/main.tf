resource "aws_iam_role" "dms_s3_access_role" {
  name = "dms-s3-access-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "dms.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dms_s3_policy_attachment" {
  role       = aws_iam_role.dms_s3_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role" "dms_secrets_role" {
  name = "dms-secrets-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "dms.${var.aws_region}.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "dms_secrets_policy" {
  role = aws_iam_role.dms_secrets_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = var.sqlserver_secrets_arn
      }
    ]
  })
}


resource "aws_iam_role" "dms-vpc-role" {
  name        = "dms-vpc-role"
  description = "Allows DMS to manage VPC"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "dms.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dms-vpc" {
  role       = aws_iam_role.dms-vpc-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
}

resource "aws_dms_replication_subnet_group" "this" {
  replication_subnet_group_description = var.replication_subnet_group_description
  replication_subnet_group_id          = var.replication_subnet_group_id
  subnet_ids                           = var.subnet_ids

  depends_on = [aws_iam_role_policy_attachment.dms-vpc]

  tags = var.tags
}

resource "aws_dms_replication_instance" "this_instance" {
  replication_instance_id     = var.replication_instance_id
  replication_instance_class  = var.replication_instance_class
  allocated_storage           = var.allocated_storage
  apply_immediately           = var.apply_immediately
  publicly_accessible         = var.publicly_accessible
  replication_subnet_group_id = aws_dms_replication_subnet_group.this.id
}

resource "aws_dms_endpoint" "endpoint_this" {
  for_each      = var.dms_endpoints
  endpoint_id   = each.key
  endpoint_type = each.value.endpoint_type
  engine_name   = each.value.engine_name
  database_name = each.value.database_name

  secrets_manager_access_role_arn = aws_iam_role.dms_secrets_role.arn
  secrets_manager_arn             = var.sqlserver_secrets_arn

  dynamic "redshift_settings" {
    for_each = try(each.value.redshift_settings != null ? [each.value.redshift_settings] : [], [])
    content {
      # bucket_folder           = rs.value.bucket_folder
      bucket_name             = redshift_settings.value.bucket_name
      encryption_mode         = redshift_settings.value.encryption_mode
      service_access_role_arn = redshift_settings.value.service_access_role_arn
    }
  }
  extra_connection_attributes = try(each.value.extra_connection_attributes, null)
}

resource "aws_dms_s3_endpoint" "endpoint_this" {
  for_each = var.dms_s3_enpoints

  endpoint_id               = each.key
  endpoint_type             = each.value.endpoint_type
  bucket_name               = each.value.bucket_name
  service_access_role_arn   = aws_iam_role.dms_s3_access_role.arn
  data_format               = each.value.data_format
  compression_type          = each.value.compression_type
  date_partition_enabled    = each.value.date_partition_enabled
  parquet_version           = each.value.parquet_version
  external_table_definition = try(each.value.external_table_definition != null ? file(each.value.external_table_definition) : "", "")
  cdc_path                  = try(each.value.cdc_path, null)
  timestamp_column_name     = try(each.value.timestamp_column_name, null)
}


resource "aws_dms_replication_task" "this" {
  for_each                 = var.dms_task
  replication_task_id      = each.key
  replication_instance_arn = aws_dms_replication_instance.this_instance.replication_instance_arn
  source_endpoint_arn      = try(aws_dms_endpoint.endpoint_this[each.value.src_endpoint].endpoint_arn, aws_dms_s3_endpoint.endpoint_this[each.value.src_endpoint].endpoint_arn)
  target_endpoint_arn      = try(aws_dms_endpoint.endpoint_this[each.value.dst_endpoint].endpoint_arn, aws_dms_s3_endpoint.endpoint_this[each.value.dst_endpoint].endpoint_arn)
  migration_type           = each.value.migration_type
  table_mappings           = try(each.value.table_mappings != null ? file(each.value.table_mappings) : "", "")
}

resource "aws_secretsmanager_secret" "this" {
  for_each = var.secrets

  name                           = each.key
  force_overwrite_replica_secret = each.value.force_overwrite_replica_secret
}

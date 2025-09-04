output "secret_id" {
  value = { for k, sid in aws_secretsmanager_secret.this : k => sid.id }
}

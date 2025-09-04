data "archive_file" "lambda_function" {
  type        = "zip"
  source_file = "${path.module}/functions/lambda_function.py"
  output_path = "${path.module}/functions/lambda_function.zip"
}

resource "aws_iam_role" "this" {
  name        = "lambda_hcm_cdc"
  path        = "/"
  description = "Allows Lambda functions to call AWS services on your behalf."
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = toset(var.lambda_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline" {
  name = "lambda_hcm_glue"
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "VisualEditor0"
        Effect = "Allow"
        Action = ["glue:StartJobRun", "glue:StartWorkflowRun"]
        Resource = [
          "arn:aws:glue:*:370519913792:job/*",
          "arn:aws:glue:*:370519913792:workflow/*"
        ]
      }
    ]
  })
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_lambda_function" "this" {
  for_each = var.lambda_function

  handler          = "lambda_function.lambda_handler"
  filename         = data.archive_file.lambda_function.output_path
  function_name    = each.key
  role             = aws_iam_role.this.arn
  source_code_hash = data.archive_file.lambda_function.output_base64sha256
  runtime          = each.value.runtime
  publish          = each.value.publish

  environment {
    variables = each.value.variables
  }

}

resource "aws_lambda_permission" "this" {
  for_each      = var.lambda_function
  statement_id  = each.value.statement_id
  action        = each.value.action
  function_name = each.key
  principal     = each.value.principal
  source_arn    = var.lambda_permissions_source_arn
}

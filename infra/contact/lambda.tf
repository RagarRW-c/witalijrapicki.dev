data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "contact" {
  function_name = "contact-form"
  role          = aws_iam_role.lambda_role.arn
  handler       = "handler.handler"
  runtime       = "python3.11"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      TO_EMAIL = "witalij.rapicki@gmail.com"
    }
  }
}
variable "env_name" {
  description = "Environment name"
}

# Run the script to get the environment variables of interest.
# This is a data source, so it will run at plan time.
data "external" "env" {
  program = ["${path.module}/env.sh"]
}

# Show the results of running the data source. This is a map of environment
# variable names to their values.
output "env" {
  value = data.external.env.result
}

locals {
  function_name               = data.external.env.result["LAMBDA_FUNCTION"]
  function_handler            = data.external.env.result["LAMBDA_FUNCTION_HANDLER"]
  function_runtime            = "go1.x"
  function_timeout_in_seconds = 5

  function_source_dir = "${path.module}"
}

resource "aws_lambda_function" "function" {
  function_name = "${local.function_name}-${var.env_name}"
  handler       = local.function_handler
  runtime       = local.function_runtime
  timeout       = local.function_timeout_in_seconds

  filename         = "main.zip"
  source_code_hash = data.archive_file.main.output_base64sha256

  role = aws_iam_role.function_role.arn

  environment {
    variables = {
      ENVIRONMENT = var.env_name
      CONJUR_ACCOUNT = data.external.env.result["CONJUR_ACCOUNT"]
      CONJUR_APPLIANCE_URL = data.external.env.result["CONJUR_APPLIANCE_URL"]
      CONJUR_CERT_FILE = data.external.env.result["CONJUR_CERT_FILE"]
      CONJUR_AUTHN_LOGIN = data.external.env.result["CONJUR_AUTHN_LOGIN"]
      CONJUR_AUTHN_API_KEY = data.external.env.result["CONJUR_AUTHN_API_KEY"]
      CONJUR_AUTHENTICATOR = data.external.env.result["CONJUR_AUTHENTICATOR"]
      PORT = data.external.env.result["DB_PORT"]
    }
  }
}

data "archive_file" "main" {
  type        = "zip"
  source_dir = "${path.module}/archive"
  output_path = "${path.module}/main.zip"
}

#resource "aws_lambda_function_url" "function" {
#  function_name      = aws_lambda_function.test.function_name
#  authorization_type = "NONE"
#}

resource "aws_iam_role" "function_role" {
  name = "${local.function_name}-${var.env_name}"

  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}
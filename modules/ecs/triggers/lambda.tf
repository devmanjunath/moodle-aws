resource "aws_cloudwatch_log_group" "this" {
  name         = "/aws/lambda/${lower(var.name)}-ecs-trigger"
  skip_destroy = false
}

module "ecs_lambda" {
  depends_on                        = [aws_cloudwatch_log_group.this]
  source                            = "terraform-aws-modules/lambda/aws"
  create_role                       = false
  runtime                           = "python3.11"
  source_path                       = "${path.module}/lambda_function.py"
  hash_extra                        = "${path.module}/lambda_function.py"
  function_name                     = "${lower(var.name)}-ecs-trigger"
  handler                           = "lambda_function.lambda_handler"
  lambda_role                       = aws_iam_role.this.arn
  use_existing_cloudwatch_log_group = true
  environment_variables = merge({
    CLUSTER_NAME = var.cluster_name
    SERVICE_NAME = lower("${var.name}-service")
  }, var.environment)
}

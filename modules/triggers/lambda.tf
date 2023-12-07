module "ecs_lambda" {
  source                            = "terraform-aws-modules/lambda/aws"
  create_role                       = false
  runtime                           = var.lambda_config["runtime"]
  timeout                           = var.lambda_config["ws-default"]["timeout"]
  memory_size                       = var.lambda_config["ws-default"]["memory"]
  source_path                       = "${path.module}/lambda_function.py"
  hash_extra                        = "${path.module}/lambda_function.py"
  function_name                     = "${var.name}-ecs-trigger"
  handler                           = "lambda_function.lambda_handler"
  use_existing_cloudwatch_log_group = true
  environment_variables             = []
}

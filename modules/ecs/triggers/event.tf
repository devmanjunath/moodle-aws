resource "aws_cloudwatch_event_bus" "this" {
  name = "${lower(var.name)}-event-bus"
}

resource "aws_cloudwatch_event_rule" "this" {
  name           = "${lower(var.name)}-event-bus"
  description    = "Capture each AWS Console Sign In"
  event_bus_name = aws_cloudwatch_event_bus.this.name

  event_pattern = jsonencode({
    "source" : ["aws.ecs"],
    "detail-type" : ["ECS Task State Change", "ECS Container Instance State Change", "ECS Deployment State Change"],
    "detail" : {
      "clusterArn" : [var.cluster_arn]
    }
  })
}

resource "aws_cloudwatch_event_target" "this" {
  rule           = aws_cloudwatch_event_rule.this.name
  event_bus_name = aws_cloudwatch_event_bus.this.name
  target_id      = "SendToLambda"
  arn            = module.ecs_lambda.lambda_function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = module.ecs_lambda.lambda_function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.this.arn
}
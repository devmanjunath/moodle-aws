resource "aws_iam_role" "this" {
  name = "role-for-${lower(var.name)}-trigger"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
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

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "ecsAccess"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "this" {
  name   = "ecs_trigger_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_policy_attachment" "this" {
  name       = "ecs-trigger-role-attachment"
  roles      = [aws_iam_role.this.name]
  policy_arn = aws_iam_policy.this.arn
}

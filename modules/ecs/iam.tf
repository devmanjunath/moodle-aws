resource "aws_iam_role" "this" {
  name = "role-for-${var.name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "efs-access-policy" {
  statement {
    sid    = "efs-access"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
      "elasticfilesystem:ClientRootAccess"
    ]

    resources = [var]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["true"]
    }
  }
}

resource "aws_iam_policy_attachment" "service_role" {
  name       = "ecs-service-role-attachment"
  roles      = [aws_iam_role.this.name]
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonECSServiceRolePolicy"
}

resource "aws_iam_policy_attachment" "execution_role" {
  name       = "ecs-execution-role-attachment"
  roles      = [aws_iam_role.this.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy_attachment" "cloudwatch_logs_role" {
  name       = "ecs-cloudwatch-role-attachment"
  roles      = [aws_iam_role.this.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

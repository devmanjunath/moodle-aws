resource "aws_codebuild_project" "this" {
  name          = "${var.name}-CICD"
  description   = "Build For ${var.name}"
  build_timeout = 5
  service_role  = aws_iam_role.this.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/devmanjunath/moodle-aws"
    git_clone_depth = 1
  }

  source_version = "develop"

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:7.0"
    type         = "LINUX_CONTAINER"
    dynamic "environment_variable" {
      for_each = var.environment_variables
      content {
        name  = environment_variable.value["name"]
        value = environment_variable.value["value"]
        type  = environment_variable.value["type"]
      }
    }
  }

  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.subnets
    security_group_ids = var.security_groups
  }
}

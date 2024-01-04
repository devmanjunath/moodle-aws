locals {
  account_id = data.aws_caller_identity.current.account_id
}

data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "this" {
  name         = "${lower(var.name)}"
  force_delete = true
}

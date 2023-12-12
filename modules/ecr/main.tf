locals {
  account_id = data.aws_caller_identity.current.account_id
}

data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "this" {
  for_each     = toset(var.image_to_build)
  name         = "${each.value}-${lower(var.name)}"
  force_delete = true
}

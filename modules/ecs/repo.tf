resource "aws_ecr_repository" "repo" {
  name                 = lower(var.name)
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

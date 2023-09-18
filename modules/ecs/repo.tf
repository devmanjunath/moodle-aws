locals {
  build_file = file("./scripts/build_image.txt")
}
data "aws_ecr_repository" "repo" {
  name = lower(var.name)
}

resource "null_resource" "build_docker_image" {
  provisioner "local-exec" {
    working_dir = "./docker"
    command     = local.build_file
  }

}

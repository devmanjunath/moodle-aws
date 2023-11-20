locals {
  account_id = data.aws_caller_identity.current.account_id
  image_name = lower(var.name)
}

resource "aws_ecr_repository" "repo" {
  name         = lower(var.name)
  force_delete = true
}

resource "null_resource" "build_docker_image" {
  depends_on = [aws_ecr_repository.repo]
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    working_dir = "${path.module}/image"
    command = join(" && ", [
      "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com",
      "docker build --no-cache -t ${local.image_name} .",
      "docker tag ${local.image_name} ${aws_ecr_repository.repo.repository_url}:latest",
      "docker push ${aws_ecr_repository.repo.repository_url}:latest",
    ])
  }
}

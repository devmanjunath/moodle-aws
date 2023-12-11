locals {
  account_id   = data.aws_caller_identity.current.account_id
  nginx_image  = lower("nginx-for-${var.name}")
  moodle_image = lower("moodle-for-${var.name}")
}

resource "aws_ecr_repository" "nginx" {
  depends_on   = [module.triggers]
  name         = lower(var.name)
  force_delete = true
}

resource "aws_ecr_repository" "moodle" {
  depends_on   = [module.triggers]
  name         = lower(var.name)
  force_delete = true
}

resource "null_resource" "build_nginx_image" {
  depends_on = [aws_ecr_repository.nginx]
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    working_dir = "${path.root}/docker/nginx"
    command = join(" && ", [
      "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com",
      "docker build --no-cache -t ${local.nginx_image} .",
      "docker tag ${local.nginx_image} ${aws_ecr_repository.nginx.repository_url}:latest",
      "docker push ${aws_ecr_repository.nginx.repository_url}:latest",
    ])
  }
}

resource "null_resource" "build_moodle_image" {
  depends_on = [aws_ecr_repository.moodle]
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    working_dir = "${path.root}/docker/moodle"
    command = join(" && ", [
      "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com",
      "docker build --no-cache -t ${local.moodle_image} .",
      "docker tag ${local.moodle_image} ${aws_ecr_repository.moodle.repository_url}:latest",
      "docker push ${aws_ecr_repository.moodle.repository_url}:latest",
    ])
  }
}

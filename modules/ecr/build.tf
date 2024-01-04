resource "null_resource" "this" {
  provisioner "local-exec" {
    working_dir = "${path.root}/docker"
    command = join(" && ", [
      "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com",
      join(" ", [
        "docker build --no-cache -t ${lower(var.name)}",
        "--build-arg host_name='${var.environment["HOST_NAME"]}'",
        "--build-arg db_host='${var.environment["DB_HOST"]}'",
        "--build-arg db_user=${var.environment["DB_USER"]}",
        "--build-arg db_pass=${var.environment["DB_PASS"]}",
        "--build-arg site_name='${var.environment["SITE_NAME"]}'",
        "--build-arg short_site_name='${var.environment["SHORT_SITE_NAME"]}'",
        "--build-arg admin_user='${var.environment["ADMIN_USER"]}'",
        "--build-arg admin_pass='${var.environment["ADMIN_PASS"]}' ."
      ]),
      "docker tag ${lower(var.name)} ${aws_ecr_repository.this.repository_url}:latest",
      "docker push ${aws_ecr_repository.this.repository_url}:latest",
    ])
  }
}

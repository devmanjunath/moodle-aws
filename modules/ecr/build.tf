resource "null_resource" "this" {
  for_each = toset(var.image_to_build)
  provisioner "local-exec" {
    working_dir = "${path.root}/docker/${each.value}"
    command = join(" && ", [
      "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com",
      "docker build --no-cache -t ${each.value}-${lower(var.name)} .",
      "docker tag ${each.value}-${lower(var.name)} ${aws_ecr_repository.this[each.value].repository_url}:latest",
      "docker push ${aws_ecr_repository.this[each.value].repository_url}:latest",
    ])
  }
}

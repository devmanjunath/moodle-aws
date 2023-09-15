resource "aws_ecr_repository" "repo" {
  # depends_on           = [docker_image.moodle_drive]
  name                 = lower(var.name)
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

# resource "docker_image" "moodle_drive" {
#   name = lower("${var.name}-image")
#   build {
#     context    = "${path.cwd}/docker/."
#     dockerfile = "${path.root}/docker/Dockerfile"
#   }
# }

data "aws_ecr_repository" "repo" {
  name = lower(var.name)
}

# resource "docker_image" "moodle_drive" {
#   name = lower("${var.name}-image")
#   build {
#     context    = "${path.cwd}/docker/."
#     dockerfile = "${path.root}/docker/Dockerfile"
#   }
# }

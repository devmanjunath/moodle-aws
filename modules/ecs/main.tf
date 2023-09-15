provider "docker" {

}

resource "aws_ecs_cluster" "ecs_cluster" {
  # depends_on = [docker_image.moodle_drive]
  name = "${var.name}-Cluster"
}

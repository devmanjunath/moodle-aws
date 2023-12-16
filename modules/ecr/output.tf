output "moodle_image_uri" {
  value = aws_ecr_repository.this["moodle"].repository_url
}



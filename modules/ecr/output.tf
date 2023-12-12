output "nginx_image_uri" {
  value = aws_ecr_repository.this["nginx"].repository_url
}

output "moodle_image_uri" {
  value = aws_ecr_repository.this["moodle"].repository_url
}



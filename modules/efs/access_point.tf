resource "aws_efs_access_point" "this" {
  file_system_id = aws_efs_file_system.this.id

  root_directory {
    path = "/"
  }

  tags = {
    "name" = "${lower(var.name)}-efs-access-point"
  }
}

resource "aws_efs_access_point" "this" {
  file_system_id = aws_efs_file_system.this.id
  posix_user {
    uid            = 1000
    gid            = 1000
    secondary_gids = [1000]
  }

  root_directory {
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = 755
    }
    path = "/"
  }

  tags = {
    "name" = "${lower(var.name)}-efs-access-point"
  }
}

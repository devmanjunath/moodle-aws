resource "aws_efs_file_system" "efs" {
  performance_mode = "maxIO"
  tags = {
    Name = "${var.name} FS"
  }
}

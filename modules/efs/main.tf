resource "aws_efs_file_system" "this" {
  performance_mode = "maxIO"
  tags = {
    Name = "${var.name} FS"
  }
}

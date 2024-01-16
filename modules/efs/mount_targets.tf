resource "aws_efs_mount_target" "mount_targets" {
  count           = length(var.subnets_to_mount)
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.subnets_to_mount[count.index]
  security_groups = var.security_group
}

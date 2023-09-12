resource "aws_efs_mount_target" "mount_targets" {
  for_each        = toset(var.subnets_to_mount)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = each.value
  security_groups = var.security_group
}

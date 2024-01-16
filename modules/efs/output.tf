output "efs_id" {
  value = aws_efs_file_system.this.id
}

output "fs_arn" {
  value = aws_efs_file_system.this.arn
}

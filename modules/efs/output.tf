output "efs_id" {
  value = aws_efs_file_system.this.id
}

output fs_arn{
  value = aws_efs_file_system.this.arn
}

output access_point_arn{
  value = aws_efs_access_point.this.arn
}
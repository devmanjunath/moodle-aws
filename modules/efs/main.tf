resource "aws_efs_file_system" "this" {
  throughput_mode = "elastic"
  tags = {
    Name = "${var.name} FS"
  }

  provisioner "local-exec" {
    when = destroy
    command = join(" ", [
      "aws backup start-backup-job",
      "--region ap-south-1",
      "--start-window-minutes 60",
      "--complete-window-minutes 120",
      "--backup-vault-name terraform_backup_vault",
      "--resource-arn ${self.arn}",
      "--iam-role-arn  arn:aws:iam::480174253711:role/service-role/AWSBackupDefaultServiceRole"
    ])
  }

  provisioner "local-exec" {
    when        = destroy
    interpreter = ["Powershell", "-Command"]
    command     = "sleep 120"
  }

  provisioner "local-exec" {
    when        = create
    interpreter = ["Powershell", "-Command"]
    command     = file("modules/efs/list.txt")
  }

  provisioner "local-exec" {
    when        = create
    interpreter = ["Powershell", "-Command"]
    command     = "Get-Content restore.txt | Set-Content -Encoding utf8 restore-utf8.txt"
  }

  provisioner "local-exec" {
    when = create
    command = join(" ", [
      "aws backup start-restore-job --region ap-south-1",
      "--iam-role-arn arn:aws:iam::480174253711:role/service-role/AWSBackupDefaultServiceRole",
      "--metadata {\"file-system-id\":\"${self.id}\",\"newFileSystem\":\"False\"}",
      "--recovery-point-arn ${replace(file("restore-utf8.txt"), "\ufeff", "")}",
    ])
  }

  provisioner "local-exec" {
    when        = create
    interpreter = ["Powershell", "-Command"]
    command     = "sleep 120"
  }
}


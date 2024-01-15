resource "aws_instance" "this" {
  count                  = var.environment == "dev" ? 1 : 0
  ami                    = data.aws_ami.this.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group
  subnet_id              = var.subnets[0]

  tags = {
    Name      = "${var.name}-${var.environment}"
    Timestamp = replace(timestamp(), ":", ".")
  }

  provisioner "local-exec" {
    when = destroy

    command = <<-EOT
      aws ec2 create-image --region ${substr(self.availability_zone, 0, 10)} --instance-id ${self.id} --name ${self.tags_all["project"]}-${self.tags["Timestamp"]}
    EOT
  }

  provisioner "local-exec" {
    when = destroy

    command = <<-EOT
      aws ec2 wait image-available --region ${substr(self.availability_zone, 0, 10)} --filters Name=name,Values=${self.tags_all["project"]}-${self.tags["Timestamp"]}
    EOT
  }
}

resource "aws_lb_target_group_attachment" "test" {
  count            = var.environment == "dev" ? 1 : 0
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.this[0].id
  port             = 80
}

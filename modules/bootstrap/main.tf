resource "aws_instance" "bootstrap_moodle" {
  ami           = "ami-0287a05f0ef0e9d9a" # us-west-2
  instance_type = "t2.medium"
  key_name      = "bootstrap-moodle"
  user_data     = file("${path.module}/bootstrap.sh")
  provisioner "file" {
    source      = "${path.module}/php.ini"
    destination = "/etc/php/8.0/fpm/php.ini"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.aws/bootstrap-moodle.pem")
      host        = self.public_ip
    }
  } 
  tags = {
    Name = "bootstrap-moodle"
  }
}

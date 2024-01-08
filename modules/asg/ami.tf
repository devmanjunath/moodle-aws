data "aws_ami" "this" {
  most_recent = true
  name_regex  = "${var.name}-[0-9]{4}-[0-9]{2}-[0-9]{2}T([0-9]+(\\.[0-9]+)+)Z"
  owners      = ["480174253711"]
}

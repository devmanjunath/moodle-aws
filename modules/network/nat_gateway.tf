resource "aws_eip" "this" {
  domain = "vpc"
  tags = {
    name = "${lower(var.name)}-eip"
  }
}
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public_subnets["ap-south-1a"].id

  tags = {
    Name = "${lower(var.name)}-nat"
  }
}

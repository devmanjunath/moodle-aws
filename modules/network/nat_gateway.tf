resource "aws_eip" "this" {
  count  = var.environment == "prod" ? 1 : 0
  domain = "vpc"
  tags = {
    name = "${lower(var.name)}-eip"
  }
}
resource "aws_nat_gateway" "this" {
  count         = var.environment == "prod" ? 1 : 0
  allocation_id = aws_eip.this[0].id
  subnet_id     = aws_subnet.public_subnets["ap-south-1a"].id

  tags = {
    Name = "${lower(var.name)}-nat"
  }
}

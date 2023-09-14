resource "aws_db_subnet_group" "default" {
  name       = lower("${var.name}-subnet-group")
  subnet_ids = var.subnets
}

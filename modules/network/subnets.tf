resource "aws_subnet" "public_subnets" {
  for_each                                    = tomap(var.public_subnets)
  vpc_id                                      = aws_vpc.main.id
  cidr_block                                  = each.value
  availability_zone                           = each.key
  map_public_ip_on_launch                     = true
  enable_resource_name_dns_a_record_on_launch = true
  tags = {
    Name = "Public Subnet ${substr(each.key, length(each.key) - 1, 2)}"
  }
}

resource "aws_subnet" "private_subnets" {
  for_each                                    = tomap(var.private_subnets)
  vpc_id                                      = aws_vpc.main.id
  cidr_block                                  = each.value
  availability_zone                           = each.key
  map_public_ip_on_launch                     = false
  enable_resource_name_dns_a_record_on_launch = false
  tags = {
    Name = "Private Subnet ${substr(each.key, length(each.key) - 1, 2)}"
  }
}


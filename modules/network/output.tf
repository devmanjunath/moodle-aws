output "vpc_id" {
  value = aws_vpc.main.id
}

output "cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "public_subnets" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "allow_ssh_sg" {
  value = aws_security_group.allow_ssh.id
}

output "allow_web_sg" {
  value = aws_security_group.allow_web.id
}

output "allow_ecs_sg" {
  value = aws_security_group.allow_ecs_api.id
}

output "allow_nfs_sg" {
  value = aws_security_group.allow_nfs.id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main_vpc.id
}

output "public_subnets" {
  description = "ID of public subnets"
  value       = [aws_subnet.public-1.id, aws_subnet.public-2.id]
}

output "private_subnets" {
  description = "ID of private subnets"
  value       = aws_subnet.private.id
}

output "server_sg_id" {
  description = "ID of server security group"
  value       = aws_security_group.server_sg.id
}

output "database_sg_id" {
  description = "ID of database security group"
  value       = aws_security_group.database_sg.id
}

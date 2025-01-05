output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "ID for the created VPC"
}

output "private_subnet_ids" {
  value       = aws_subnet.private_subnet[*].id
  description = "ID's for the created private subnets"
}

output "public_subnet_ids" {
  value       = aws_subnet.public_subnet[*].id
  description = "ID's for the created private subnets"
}

output "vpc_id" {
  description = "ID du VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "IDs des sous-réseaux publics"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "IDs des sous-réseaux privés"
  value       = aws_subnet.private[*].id
}

output "security_group_id" {
  description = "ID du security group des nodes"
  value       = aws_security_group.eks_nodes.id
}
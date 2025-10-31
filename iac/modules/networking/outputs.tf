output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
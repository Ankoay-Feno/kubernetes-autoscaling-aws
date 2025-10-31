# outputs.tf
output "cluster_id" {
  description = "ID du cluster EKS"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint du cluster EKS"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "Nom du cluster EKS"
  value       = module.eks.cluster_name
}

output "vpc_id" {
  description = "ID du VPC"
  value       = module.networking.vpc_id
}

output "node_group_id" {
  description = "ID du node group"
  value       = module.eks.node_group_id
}
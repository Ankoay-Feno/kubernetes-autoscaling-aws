# outputs.tf - Fichier principal
output "cluster_id" {
  description = "ID du cluster EKS"
  value       = module.eks.cluster_id
}

output "cluster_arn" {
  description = "ARN du cluster EKS"
  value       = module.eks.cluster_arn
}

output "cluster_endpoint" {
  description = "Endpoint du cluster EKS"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Certificate authority data pour le cluster"
  value       = module.eks.cluster_certificate_authority_data
}

output "node_group_arn" {
  description = "ARN du node group"
  value       = module.eks.node_group_arn
}

output "node_group_status" {
  description = "Statut du node group"
  value       = module.eks.node_group_status
}

output "configure_kubectl" {
  description = "Commande pour configurer kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}"
}

output "vpc_id" {
  description = "ID du VPC"
  value       = module.networking.vpc_id
}

output "cluster_autoscaler_role_arn" {
  description = "ARN du rôle IAM du Cluster Autoscaler"
  value       = module.autoscaling.cluster_autoscaler_role_arn
}
output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

output "node_group_name" {
  description = "EKS node group name"
  value       = aws_eks_node_group.workers.node_group_name
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}

output "cluster_id" {
  description = "ID of the EKS cluster"
  value = aws_eks_cluster.main.id
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value = aws_eks_cluster.main.arn
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value = aws_eks_cluster.main.certificate_authority[0].data
}

output "node_group_arn" {
  description = "ARN of the node group"
  value = aws_eks_node_group.workers.arn
}

output "node_group_status" {
  description = "Status of the node group"
  value = aws_eks_node_group.workers.status
}
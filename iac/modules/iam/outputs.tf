output "cluster_role_arn" {
  description = "ARN du rôle IAM du cluster"
  value       = aws_iam_role.eks_cluster.arn
}

output "node_group_role_arn" {
  description = "ARN du rôle IAM des nodes"
  value       = aws_iam_role.eks_node_group.arn
}
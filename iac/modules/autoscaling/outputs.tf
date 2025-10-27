output "cluster_autoscaler_role_arn" {
  description = "ARN du rôle IAM du Cluster Autoscaler"
  value       = aws_iam_role.cluster_autoscaler.arn
}
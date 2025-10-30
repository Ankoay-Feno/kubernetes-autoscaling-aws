variable "cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
}

variable "aws_region" {
  description = "Région AWS"
  type        = string
}

variable "vpc_id" {
  description = "ID du VPC"
  type        = string
}

variable "private_subnets" {
  description = "Liste des sous-réseaux privés"
  type        = list(string)
}

variable "public_subnets" {
  description = "Liste des sous-réseaux publics"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "ARN du rôle IAM du cluster"
  type        = string
}

variable "node_group_role_arn" {
  description = "ARN du rôle IAM des nodes"
  type        = string
}
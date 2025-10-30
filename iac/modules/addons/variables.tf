variable "cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
}

variable "cluster_endpoint" {
  description = "Endpoint du cluster EKS"
  type        = string
}

variable "cluster_ca_data" {
  description = "Certificate authority data du cluster"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN du provider OIDC"
  type        = string
}

variable "oidc_provider_url" {
  description = "URL du provider OIDC"
  type        = string
}

variable "node_group_name" {
  description = "Nom du node group"
  type        = string
}

variable "aws_region" {
  description = ""
  type = string
}
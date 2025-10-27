variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "cluster_role_arn" {
  description = "ARN of the EKS cluster role"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of the EKS node group role"
  type        = string
}

variable "addon_version" {
  description = "Version of the EKS addon"
  type        = string
}
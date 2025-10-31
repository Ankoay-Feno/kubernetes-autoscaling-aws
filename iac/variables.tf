# variables.tf
variable "aws_region" {
  description = "Région AWS"
  type        = string
  default     = "eu-west-3"
}

variable "cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
  default     = "my-eks-cluster"
}

variable "cluster_version" {
  description = "Version du cluster EKS"
  type        = string
  default     = "1.30"
}

variable "vpc_cidr" {
  description = "CIDR du VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_types" {
  description = "Types d'instances pour les nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "desired_size" {
  description = "Nombre désiré de nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Nombre maximum de nodes"
  type        = number
  default     = 5
}

variable "min_size" {
  description = "Nombre minimum de nodes"
  type        = number
  default     = 1
}
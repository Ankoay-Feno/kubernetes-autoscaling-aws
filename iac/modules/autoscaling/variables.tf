variable "cluster_name" {
  type = string
}

variable "cluster_oidc_issuer_url" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "eu-west-3"
}
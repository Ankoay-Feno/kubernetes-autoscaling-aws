
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_eks_cluster_auth" "main" {
  name = module.eks.cluster_name
}

# Appel des modules
module "networking" {
  source = "./modules/networking"
  
  cluster_name       = var.cluster_name
  vpc_cidr          = var.vpc_cidr
  availability_zones = data.aws_availability_zones.available.names
}

module "iam" {
  source = "./modules/iam"
  
  cluster_name = var.cluster_name
}

module "eks" {
  source = "./modules/eks"
  
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.networking.vpc_id
  subnet_ids      = module.networking.subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn   = module.iam.node_role_arn
  instance_types  = var.instance_types
  desired_size    = var.desired_size
  max_size        = var.max_size
  min_size        = var.min_size
}

module "addons" {
  source = "./modules/addons"
  
  cluster_name             = module.eks.cluster_name
  cluster_oidc_issuer_url  = module.eks.cluster_oidc_issuer_url
  cluster_endpoint         = module.eks.cluster_endpoint
  cluster_ca_certificate   = module.eks.cluster_certificate_authority
  
  providers = {
    kubernetes = kubernetes.eks
    helm       = helm.eks
  }
}

module "autoscaling" {
  source = "./modules/autoscaling"
  
  cluster_name             = module.eks.cluster_name
  cluster_oidc_issuer_url  = module.eks.cluster_oidc_issuer_url
  oidc_provider_arn        = module.eks.oidc_provider_arn
  cluster_endpoint         = module.eks.cluster_endpoint
  cluster_ca_certificate   = module.eks.cluster_certificate_authority
  aws_region               = var.aws_region
  
  providers = {
    kubernetes = kubernetes.eks
  }
}
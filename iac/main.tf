# main.tf
# Module VPC
module "vpc" {
  source = "./modules/vpc"

  cluster_name = var.cluster_name
  aws_region   = var.aws_region
}

# Module IAM
module "iam" {
  source = "./modules/iam"

  cluster_name = var.cluster_name
}

# Module EKS
module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  aws_region      = var.aws_region
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets

  cluster_role_arn    = module.iam.cluster_role_arn
  node_group_role_arn = module.iam.node_group_role_arn
}

# Module Addons
module "addons" {
  source = "./modules/addons"

  aws_region = var.aws_region
  cluster_name        = var.cluster_name
  cluster_endpoint    = module.eks.cluster_endpoint
  cluster_ca_data     = module.eks.cluster_certificate_authority_data
  oidc_provider_arn   = module.eks.oidc_provider_arn
  oidc_provider_url   = module.eks.oidc_provider_url
  node_group_name     = module.eks.node_group_name

  # Dépendre du module EKS pour s'assurer que le cluster est créé
  depends_on = [module.eks]
}
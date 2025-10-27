# #VPC pour EKS
# resource "aws_vpc" "main" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support   = true

#   tags = {
#     Name = "my-eks-cluster-vpc"
#   }
# }

# # Sous-réseaux publics
# resource "aws_subnet" "public" {
#   count = 2

#   vpc_id            = aws_vpc.main.id
#   cidr_block        = cidrsubnet("10.0.0.0/16", 8, count.index + 1)
#   availability_zone = data.aws_availability_zones.available.names[count.index]

#   map_public_ip_on_launch = true

#   depends_on = [ aws_vpc.main ]
# }

# # Sous-réseaux privés
# resource "aws_subnet" "private" {
#   count = 2

#   vpc_id            = aws_vpc.main.id
#   cidr_block        = cidrsubnet("10.0.0.0/16", 8, count.index + 3)
#   availability_zone = data.aws_availability_zones.available.names[count.index]

#   depends_on = [ aws_vpc.main ]
# }

# # Internet Gateway
# resource "aws_internet_gateway" "main" {
#   vpc_id = aws_vpc.main.id
  
#   depends_on = [
#     aws_vpc.main
#   ]
# }

# # NAT Gateway
# resource "aws_eip" "nat" {
#   domain = "vpc"

# }

# resource "aws_nat_gateway" "main" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public[0].id

#   tags = {
#     Name = "my-eks-cluster-nat"
#   }

#   depends_on = [
#     aws_eip.nat,
#     aws_internet_gateway.main,
#     aws_subnet.public
#   ]
# }

# # Tables de routage
# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.main.id
#   }

#   depends_on = [ 
#     aws_internet_gateway.main, 
#     aws_vpc.main 
#   ]
# }

# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.main.id
#   }

#   depends_on = [ 
#     aws_nat_gateway.main, 
#     aws_vpc.main 
#   ]
# }

# # Associations des tables de routage
# resource "aws_route_table_association" "public" {
#   count = 2

#   subnet_id      = aws_subnet.public[count.index].id
#   route_table_id = aws_route_table.public.id
#   depends_on = [ 
#     aws_subnet.public,
#     aws_route_table.public
#   ]
# }

# resource "aws_route_table_association" "private" {
#   count = 2

#   subnet_id      = aws_subnet.private[count.index].id
#   route_table_id = aws_route_table.private.id
#   depends_on = [ 
#     aws_subnet.private, 
#     aws_route_table.private 
#   ]
# }

# # Rôle IAM pour le cluster EKS
# resource "aws_iam_role" "eks_cluster" {
#   name = "my-eks-cluster-cluster-role"

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "eks.amazonaws.com"
#       }
#     },
#         {
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#   role       = aws_iam_role.eks_cluster.name
#   depends_on = [ aws_iam_role.eks_cluster ]
# }


# resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
#   role       = aws_iam_role.eks_cluster.name
#   depends_on = [ aws_iam_role.eks_cluster ]
# }

# # Rôle IAM pour les nodes
# resource "aws_iam_role" "eks_node_group" {
#   name = "my-eks-cluster-node-group-role"

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })
# }

# resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
#   role       =  aws_iam_role.eks_node_group.name
#   depends_on = [ aws_iam_role.eks_cluster ]
# }

# resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.eks_node_group.name
#   depends_on = [ aws_iam_role.eks_node_group ]
# }

# resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.eks_node_group.name
#   depends_on = [ aws_iam_role.eks_node_group ]
# }

# resource "aws_iam_role_policy_attachment" "ec2_container_registry_read_only" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.eks_node_group.name
#   depends_on = [ aws_iam_role.eks_node_group ]
# }

# resource "aws_iam_role_policy_attachment" "autoscaling_full_access" {
#   policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
#   role       = aws_iam_role.eks_node_group.name
#   depends_on = [ aws_iam_role.eks_node_group ]
# }



# # Cluster EKS
# resource "aws_eks_cluster" "main" {
#   name     = "my-eks-cluster"
#   version  = "1.28"
#   role_arn = aws_iam_role.eks_cluster.arn

#   vpc_config {
#     subnet_ids = module.networking.subnet_ids
#     endpoint_private_access = true
#     endpoint_public_access  = true
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.eks_cluster_policy,
#     aws_iam_role_policy_attachment.eks_vpc_resource_controller,
#     module.networking
#   ]

# }


# # Node Group avec 3 nodes
# resource "aws_eks_node_group" "workers" {
#   cluster_name    = aws_eks_cluster.main.name
#   node_group_name = "worker-nodes"
#   node_role_arn   = aws_iam_role.eks_node_group.arn
#   subnet_ids      = module.networking.private_subnet_ids

#   instance_types = ["t2.medium"]

#   scaling_config {
#     desired_size = 1
#     max_size     = 5
#     min_size     = 1
#   }

#   update_config {
#     max_unavailable = 1
#   }

#   depends_on = [
#     aws_eks_cluster.main,
#     aws_iam_role_policy_attachment.eks_worker_node_policy,
#     aws_iam_role_policy_attachment.eks_cni_policy,
#     aws_iam_role_policy_attachment.ec2_container_registry_read_only,
#     aws_iam_role_policy_attachment.autoscaling_full_access
#   ]

#   tags = {
#     "k8s.io/cluster-autoscaler/${aws_eks_cluster.main.name}" = "owned"
#     "k8s.io/cluster-autoscaler/enabled"                        = "TRUE"
#   }
# }


# resource "aws_eks_addon" "ebs_csi" {
#   cluster_name             = aws_eks_cluster.main.name
#   addon_name               = "aws-ebs-csi-driver"
#   addon_version            = "v1.30.0-eksbuild.1"
  
#   depends_on = [ 
#     aws_eks_node_group.workers,
#     aws_iam_role_policy_attachment.ebs_csi_driver_policy
#   ]
# }

# # # Data sources
# # data "aws_availability_zones" "available" {
# #   state = "available"
# # }

# data "aws_eks_cluster_auth" "main" {
#   name = aws_eks_cluster.main.name
#   depends_on = [ aws_eks_cluster.main ]
# }

# # Provider Kubernetes
# provider "kubernetes" {
#   host                   = aws_eks_cluster.main.endpoint
#   cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.main.token
# }




# # autoscaling


# # =========================================
# # CLUSTER AUTOSCALER - À AJOUTER À LA FIN DE MAIN.TF
# # =========================================

# # OIDC Provider pour EKS
# data "tls_certificate" "eks" {
#   url = aws_eks_cluster.main.identity[0].oidc[0].issuer
# }

# resource "aws_iam_openid_connect_provider" "eks" {
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
#   url             = aws_eks_cluster.main.identity[0].oidc[0].issuer

#   tags = {
#     Name = "my-eks-cluster-oidc"
#   }

#   depends_on = [aws_eks_cluster.main]
# }

# # IAM Role pour Cluster Autoscaler
# resource "aws_iam_role" "cluster_autoscaler" {
#   name = "my-eks-cluster-autoscaler-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRoleWithWebIdentity"
#       Effect = "Allow"
#       Principal = {
#         Federated = aws_iam_openid_connect_provider.eks.arn
#       }
#       Condition = {
#         StringEquals = {
#           "${replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:kube-system:cluster-autoscaler"
#           "${replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")}:aud" = "sts.amazonaws.com"
#         }
#       }
#     }]
#   })

#   depends_on = [aws_iam_openid_connect_provider.eks]
# }

# # Policy IAM pour Cluster Autoscaler
# resource "aws_iam_role_policy" "cluster_autoscaler" {
#   name = "cluster-autoscaler-policy"
#   role = aws_iam_role.cluster_autoscaler.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "autoscaling:DescribeAutoScalingGroups",
#           "autoscaling:DescribeAutoScalingInstances",
#           "autoscaling:DescribeLaunchConfigurations",
#           "autoscaling:DescribeScalingActivities",
#           "autoscaling:DescribeTags",
#           "ec2:DescribeInstanceTypes",
#           "ec2:DescribeLaunchTemplateVersions"
#         ]
#         Resource = "*"
#       },
#       {
#         Effect = "Allow"
#         Action = [
#           "autoscaling:SetDesiredCapacity",
#           "autoscaling:TerminateInstanceInAutoScalingGroup",
#           "ec2:DescribeImages",
#           "ec2:GetInstanceTypesFromInstanceRequirements",
#           "eks:DescribeNodegroup"
#         ]
#         Resource = "*"
#       }
#     ]
#   })

#   depends_on = [aws_iam_role.cluster_autoscaler]
# }

# # ServiceAccount Kubernetes
# resource "kubernetes_service_account" "cluster_autoscaler" {
#   metadata {
#     name      = "cluster-autoscaler"
#     namespace = "kube-system"
#     labels = {
#       "k8s-addon" = "cluster-autoscaler.addons.k8s.io"
#       "k8s-app"   = "cluster-autoscaler"
#     }
#     annotations = {
#       "eks.amazonaws.com/role-arn" = aws_iam_role.cluster_autoscaler.arn
#     }
#   }

#   depends_on = [
#     aws_eks_cluster.main,
#     aws_iam_role.cluster_autoscaler
#   ]
# }

# # ClusterRole
# resource "kubernetes_cluster_role" "cluster_autoscaler" {
#   metadata {
#     name = "cluster-autoscaler"
#     labels = {
#       "k8s-addon" = "cluster-autoscaler.addons.k8s.io"
#       "k8s-app"   = "cluster-autoscaler"
#     }
#   }

#   rule {
#     api_groups = [""]
#     resources  = ["events", "endpoints"]
#     verbs      = ["create", "patch"]
#   }

#   rule {
#     api_groups = [""]
#     resources  = ["pods/eviction"]
#     verbs      = ["create"]
#   }

#   rule {
#     api_groups = [""]
#     resources  = ["pods/status"]
#     verbs      = ["update"]
#   }

#   rule {
#     api_groups     = [""]
#     resources      = ["endpoints"]
#     resource_names = ["cluster-autoscaler"]
#     verbs          = ["get", "update"]
#   }

#   rule {
#     api_groups = [""]
#     resources  = ["nodes"]
#     verbs      = ["watch", "list", "get", "update"]
#   }

#   rule {
#     api_groups = [""]
#     resources  = ["namespaces", "pods", "services", "replicationcontrollers", "persistentvolumeclaims", "persistentvolumes"]
#     verbs      = ["watch", "list", "get"]
#   }

#   rule {
#     api_groups = ["extensions"]
#     resources  = ["replicasets", "daemonsets"]
#     verbs      = ["watch", "list", "get"]
#   }

#   rule {
#     api_groups = ["policy"]
#     resources  = ["poddisruptionbudgets"]
#     verbs      = ["watch", "list"]
#   }

#   rule {
#     api_groups = ["apps"]
#     resources  = ["statefulsets", "replicasets", "daemonsets"]
#     verbs      = ["watch", "list", "get"]
#   }

#   rule {
#     api_groups = ["storage.k8s.io"]
#     resources  = ["storageclasses", "csinodes", "csidrivers", "csistoragecapacities"]
#     verbs      = ["watch", "list", "get"]
#   }

#   rule {
#     api_groups = ["batch", "extensions"]
#     resources  = ["jobs"]
#     verbs      = ["get", "list", "watch", "patch"]
#   }

#   rule {
#     api_groups = ["coordination.k8s.io"]
#     resources  = ["leases"]
#     verbs      = ["create"]
#   }

#   rule {
#     api_groups     = ["coordination.k8s.io"]
#     resource_names = ["cluster-autoscaler"]
#     resources      = ["leases"]
#     verbs          = ["get", "update"]
#   }

#   depends_on = [aws_eks_cluster.main]
# }

# # ClusterRoleBinding
# resource "kubernetes_cluster_role_binding" "cluster_autoscaler" {
#   metadata {
#     name = "cluster-autoscaler"
#     labels = {
#       "k8s-addon" = "cluster-autoscaler.addons.k8s.io"
#       "k8s-app"   = "cluster-autoscaler"
#     }
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "ClusterRole"
#     name      = kubernetes_cluster_role.cluster_autoscaler.metadata[0].name
#   }

#   subject {
#     kind      = "ServiceAccount"
#     name      = kubernetes_service_account.cluster_autoscaler.metadata[0].name
#     namespace = "kube-system"
#   }

#   depends_on = [
#     kubernetes_cluster_role.cluster_autoscaler,
#     kubernetes_service_account.cluster_autoscaler
#   ]
# }

# # Role
# resource "kubernetes_role" "cluster_autoscaler" {
#   metadata {
#     name      = "cluster-autoscaler"
#     namespace = "kube-system"
#     labels = {
#       "k8s-addon" = "cluster-autoscaler.addons.k8s.io"
#       "k8s-app"   = "cluster-autoscaler"
#     }
#   }

#   rule {
#     api_groups = [""]
#     resources  = ["configmaps"]
#     verbs      = ["create", "list", "watch"]
#   }

#   rule {
#     api_groups     = [""]
#     resources      = ["configmaps"]
#     resource_names = ["cluster-autoscaler-status", "cluster-autoscaler-priority-expander"]
#     verbs          = ["delete", "get", "update", "watch"]
#   }

#   depends_on = [aws_eks_cluster.main]
# }

# # RoleBinding
# resource "kubernetes_role_binding" "cluster_autoscaler" {
#   metadata {
#     name      = "cluster-autoscaler"
#     namespace = "kube-system"
#     labels = {
#       "k8s-addon" = "cluster-autoscaler.addons.k8s.io"
#       "k8s-app"   = "cluster-autoscaler"
#     }
#   }

#   role_ref {
#     api_group = "rbac.authorization.k8s.io"
#     kind      = "Role"
#     name      = kubernetes_role.cluster_autoscaler.metadata[0].name
#   }

#   subject {
#     kind      = "ServiceAccount"
#     name      = kubernetes_service_account.cluster_autoscaler.metadata[0].name
#     namespace = "kube-system"
#   }

#   depends_on = [
#     kubernetes_role.cluster_autoscaler,
#     kubernetes_service_account.cluster_autoscaler
#   ]
# }

# # Deployment Cluster Autoscaler
# resource "kubernetes_deployment" "cluster_autoscaler" {
#   metadata {
#     name      = "cluster-autoscaler"
#     namespace = "kube-system"
#     labels = {
#       "app" = "cluster-autoscaler"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         "app" = "cluster-autoscaler"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           "app" = "cluster-autoscaler"
#         }
#         annotations = {
#           "prometheus.io/scrape" = "true"
#           "prometheus.io/port"   = "8085"
#         }
#       }

#       spec {
#         priority_class_name  = "system-cluster-critical"
#         service_account_name = kubernetes_service_account.cluster_autoscaler.metadata[0].name

#         container {
#           image = "registry.k8s.io/autoscaling/cluster-autoscaler:v1.28.2"
#           name  = "cluster-autoscaler"

#           resources {
#             limits = {
#               cpu    = "100m"
#               memory = "600Mi"
#             }
#             requests = {
#               cpu    = "100m"
#               memory = "600Mi"
#             }
#           }

#           command = [
#             "./cluster-autoscaler",
#             "--v=4",
#             "--stderrthreshold=info",
#             "--cloud-provider=aws",
#             "--skip-nodes-with-local-storage=false",
#             "--expander=least-waste",
#             "--node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/my-eks-cluster",
#             "--balance-similar-node-groups",
#             "--skip-nodes-with-system-pods=false"
#           ]

#           volume_mount {
#             name       = "ssl-certs"
#             mount_path = "/etc/ssl/certs/ca-certificates.crt"
#             read_only  = true
#           }

#           image_pull_policy = "Always"

#           security_context {
#             allow_privilege_escalation = false
#             capabilities {
#               drop = ["ALL"]
#             }
#             read_only_root_filesystem = true
#           }
#         }

#         volume {
#           name = "ssl-certs"
#           host_path {
#             path = "/etc/ssl/certs/ca-bundle.crt"
#           }
#         }

#         security_context {
#           run_as_non_root = true
#           run_as_user     = 65534
#           fs_group        = 65534
#           seccomp_profile {
#             type = "RuntimeDefault"
#           }
#         }
#       }
#     }
#   }

#   depends_on = [
#     kubernetes_service_account.cluster_autoscaler,
#     kubernetes_cluster_role_binding.cluster_autoscaler,
#     kubernetes_role_binding.cluster_autoscaler,
#     aws_eks_node_group.workers
#   ]
# }

# # Output
# output "cluster_autoscaler_role_arn" {
#   value       = aws_iam_role.cluster_autoscaler.arn
#   description = "ARN du rôle IAM du Cluster Autoscaler"
# }







# main.tf
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority)
  token                  = data.aws_eks_cluster_auth.main.token
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_eks_cluster_auth" "main" {
  name = module.eks.cluster_name
}

# Appel des modules
module "networking" {
  source = "./modules/networking"
  
  vpc_cidr            = var.vpc_cidr
  availability_zones  = data.aws_availability_zones.available.names
  cluster_name        = var.cluster_name
}

module "iam" {
  source = "./modules/iam"
  
  cluster_name = var.cluster_name
}

module "eks" {
  source = "./modules/eks"
  
  cluster_name     = var.cluster_name
  cluster_version  = var.cluster_version
  vpc_id           = module.networking.vpc_id
  subnet_ids       = module.networking.subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  cluster_role_arn = module.iam.cluster_role_arn
  node_role_arn    = module.iam.node_role_arn
  addon_version    = var.addon_version
}

module "autoscaling" {
  source = "./modules/autoscaling"
  
  cluster_name    = module.eks.cluster_name
  cluster_oidc_url = module.eks.cluster_oidc_issuer_url
  node_group_name = module.eks.node_group_name
  
  depends_on = [module.eks]
}
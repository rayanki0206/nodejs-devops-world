module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.15.1"

  name    = var.eks_cluster_name
  kubernetes_version = var.eks_cluster_version
  endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  enable_cluster_creator_admin_permissions = true
  enable_irsa = true

  addons = {
      vpc-cni = {
        before_compute              = true 
        resolve_conflicts_on_create = "OVERWRITE"
        resolve_conflicts_on_update = "OVERWRITE"
      }
      kube-proxy = {
        before_compute = true
      }
      coredns = {
        resolve_conflicts_on_create = "OVERWRITE"
      }
    }

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.micro"]
      desired_size   = 2
      min_size       = 1
      max_size       = 3
    }
  }
}


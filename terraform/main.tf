terraform {
  backend "s3" {
    bucket = "vrayanki-terraform-state-bucket"
    key    = "state/terraform.tfstate"
    region = "ap-south-1"
  }

  required_version = "~> 1.12.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
  }
}

# This fetches the fresh security token internally through the AWS provider
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "aws" {
    region = var.aws_region
}
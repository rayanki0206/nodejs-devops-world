variable "aws_region" {
    description = "The AWS region to deploy resources in"
    type        = string
    default     = "ap-south-1"
}

variable "vpc_name" {
    description = "The name of the VPC"
    type        = string
    default     = "demo-eks-vpc"
}

variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "eks_cluster_name" {
    description = "The name of the EKS cluster"
    type        = string
    default     = "demo-eks-cluster"
}

variable "eks_cluster_version" {
    description = "The Kubernetes version for the EKS cluster"
    type        = string
    default     = "1.35"
}
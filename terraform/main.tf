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
  }

}

provider "aws" {
    region = var.aws_region
}

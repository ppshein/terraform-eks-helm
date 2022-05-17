terraform {
  required_version = ">= 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    region         = "ap-southeast-1"
    role_arn       = "arn:aws:iam::xxxxxxxxxxxx:role/this-is-assumed-role"
    bucket         = "devops-tfstate-ap"
    key            = "eks-terraform.tfstate"
    dynamodb_table = "devops-tfstate-ap-lock"
    encrypt        = true
  }
}

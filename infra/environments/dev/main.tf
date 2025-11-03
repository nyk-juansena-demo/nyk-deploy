terraform {
  required_version = ">= 1.6.0"
  backend "s3" {
    bucket         = "nyk-tf-state-8763"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "nyk-tf-lock"
    encrypt        = true
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0" 
    }
  }
}
provider "aws" { 
  region = var.region 
  }

module "ecr" {
  source    = "../../modules/ecr"
  region    = var.region
  repo_name = "nyk-demo-app"
  tags      = var.tags
}

module "iam_ci" {
  source    = "../../modules/iam_ci_role"
  role_name = "nyk-demo-ci-role"
  tags      = var.tags
}

output "ecr_repo" { value = module.ecr.repository_url }
output "ci_role"  { value = module.iam_ci.role_name }

terraform {
  required_version = ">= 1.5"

  backend "s3" {
    bucket         = "witalijrapicki-tfstate"
    key            = "frontend/prod/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

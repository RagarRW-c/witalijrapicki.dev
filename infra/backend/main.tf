terraform {
  required_version = ">= 1.5"

  /*backend "s3" {
    bucket = "witalijrapicki-tfstate"
    key = "portfolio/terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "terraform-lock"
    encrypt = true
  }*/

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

#provider "aws" {
#  region = "eu-central-1"
#}
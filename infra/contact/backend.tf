terraform {
  backend "s3" {
    bucket         = "witalijrapicki-tfstate"
    key            = "contact/prod/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

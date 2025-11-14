terraform {
  backend "s3" {
    bucket         = "infra-terraform-states"
    key            = "prod/core/inventory/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "infra-terraform-locks"
    encrypt        = true
  }
}
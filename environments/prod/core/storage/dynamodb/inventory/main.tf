terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "aws_region" {
  description = "Região da AWS para este ambiente"
  type        = string
  default     = "us-east-1"
}

provider "aws" {
  region = var.aws_region
}


module "iac_inventory_db" {
  source = "../../modules/dynamodb-table" 

  table_name   = "iac_inventory"
  hash_key     = "resource_name"
  range_key    = "stack_id"
  billing_mode = "PAY_PER_REQUEST"

  attributes = [
    {
      name = "resource_name"
      type = "S"
    },
    {
      name = "stack_id"
      type = "S"
    }
  ]

  # Adiciona as tags específicas deste ambiente/uso
  extra_tags = {
    Purpose     = "iac-inventory"
    Environment = "prod"
  }
}
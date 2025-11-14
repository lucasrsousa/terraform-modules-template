terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "env" {
  description = "Environment"
  type        = string
  default     = "prod"
}

variable "aws_region" { 
  description = "Região do S3"
  type        = string
  default     = "us-east-1"
}

module "vpc" {
  source                               = "../../../../modules/core/network/vpc"
  env                                  = var.env
  
  cidr_block                           = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block     = true
  nome                                 = "prod-vpc"

  tags = {
    Environment = var.env
    ManagedBy   = "terraform"
  }
}

module "subnet" {
  source  = "../../../../modules/core/network/subnet"
  env     = var.env

  vpc_id  = module.vpc.vpc_id

  subnets = {
    "prod-web-public-1a-1" = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
      tags = { Role = "web" }
    },
    "prod-web-public-1b-1" = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1b"
      tags = { Role = "web" }
    },
    "prod-app-private-1b-1" = {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "us-east-1b"
      tags = { Role = "app" }
    },
    "prod-app-private-1a-1" = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1a"
      tags = { Role = "app" }
    },
    "prod-db-private-1a-1" = {
      cidr_block        = "10.0.5.0/24"
      availability_zone = "us-east-1a"
      tags = { Role = "db" }
    },
    "prod-db-private-1b-1" = {
      cidr_block        = "10.0.6.0/24"
      availability_zone = "us-east-1b"
      tags = { Role = "db" }
    },
    "prod-db-private-1c-1" = {
      cidr_block        = "10.0.7.0/24"
      availability_zone = "us-east-1c"
      tags = { Role = "db" }
    }
  }

  tags = {
    Environment = var.env
    ManagedBy   = "terraform"
  }
}

module "route" {
  source = "../../../../modules/core/network/route"
  env    = var.env
  
  vpc_id = module.vpc.vpc_id

  # Criar um mapa de rotas para associações usando os nomes dos recursos do módulo de subnets
  routes = [
    {
      name = "prod-public-rt"
      associations = [
        module.subnet.subnet_ids["prod-web-public-1a-1"],
        module.subnet.subnet_ids["prod-web-public-1b-1"]
      ]
    },
    {
      name = "prod-private-rt"
      associations = [
        module.subnet.subnet_ids["prod-app-private-1a-1"],
        module.subnet.subnet_ids["prod-app-private-1b-1"],
        module.subnet.subnet_ids["prod-db-private-1a-1"],
        module.subnet.subnet_ids["prod-db-private-1b-1"],
        module.subnet.subnet_ids["prod-db-private-1c-1"]
      ]
    }
  ]

  tags = {
    Environment = var.env
    ManagedBy   = "terraform"
  }
}

module "igw" {
  source = "../../../../modules/core/network/igw"
  env    = var.env

  vpc_id = module.vpc.vpc_id
  enable_ipv6_public_route = true
  
  public_route_table_ids = [
    module.route.route_table_ids["prod-public-rt"]
  ]

  tags = {
    Environment = var.env
    ManagedBy   = "terraform"
    Name   = "prod-igw"
  }
}

module "eip" {
  source = "../../../../modules/core/network/eip"
  env    = var.env

  eips = {
    "prod-nat-elasticip" = { tags = { Role = "prod-nat" } }
  }

  tags = {
    Environment = var.env
    ManagedBy   = "terraform"
  }
}

module "nat_gateway" {
  source        = "../../../../modules/core/network/nat"
  env    = var.env

  nats = [
    {
      name          = "prod-nat"
      allocation_id = module.eip.eip_ids["prod-nat-elasticip"] # EIP
      subnet_id     = module.subnet.subnet_ids["prod-web-public-1a-1"]  # Subnet pública
    }
  ]

  tags = {
    Environment = var.env
    ManagedBy   = "terraform"
  }
}
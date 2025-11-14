resource "aws_vpc" "basic_vpc" {
  cidr_block                     = var.cidr_block
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block

  tags = merge(
    var.tags,
    {
      Name = var.nome
    }
  )
}

module "inventory_item" {
  source        = "../../utils/add_item_inventory"
  stack_id      = "${var.env}/modules/core/network/vpc/${var.nome}"
  resource_type = "vpc"
  resource_name = var.nome
  region        = var.aws_region

  metadata = {
    resources = {
      vpc = {
        id         = aws_vpc.basic_vpc.id
        cidr_block = aws_vpc.basic_vpc.cidr_block
        ipv6_block = aws_vpc.basic_vpc.ipv6_cidr_block
      }
    }

    modules = [
      "core/network/vpc"
    ]

    version = "2025.11.12"
  }
}

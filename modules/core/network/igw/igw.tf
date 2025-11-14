resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id
  tags   = var.tags
}

resource "aws_route" "public_internet_access_ipv4" {
  for_each              = toset(var.public_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route" "public_internet_access_ipv6" {
  for_each = var.enable_ipv6_public_route ? toset(var.public_route_table_ids) : toset([])
  route_table_id          = each.value
  destination_ipv6_cidr_block = "::/0"
  gateway_id              = aws_internet_gateway.this.id
  depends_on             = [aws_internet_gateway.this]
}

module "inventory_item" {
  source        = "../../utils/add_item_inventory"
  stack_id      = "${var.env}/core/network/igw/main"
  resource_type = "igw"
  resource_name = "igw_main"
  region        = var.aws_region

  metadata = {
    resources = {
      igw = {
        vpc_id = var.vpc_id
      }
    }

    modules = [
      "core/network/route"
    ]

    version = "2025.11.12"
  }
}
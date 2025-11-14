resource "aws_subnet" "this" {
  for_each = var.subnets

  vpc_id      = var.vpc_id
  cidr_block  = each.value.cidr_block
  availability_zone = each.value.availability_zone

  map_public_ip_on_launch        = lookup(each.value, "map_public_ip", false)
  assign_ipv6_address_on_creation = lookup(each.value, "assign_ipv6", false)
  ipv6_cidr_block                = lookup(each.value, "ipv6_cidr_block", null)

  lifecycle {
    ignore_changes = [ipv6_cidr_block]
  }

  tags = merge(
    var.tags,
    lookup(each.value, "tags", {}),
    { Name = each.key }
  )
}

module "inventory_item" {
  for_each = aws_subnet.this

  source        = "../../utils/add_item_inventory"

  stack_id      = "${var.env}/modules/core/network/subnet/${each.key}"
  resource_type = "subnet"
  resource_name = each.key
  region        = var.aws_region

  metadata = {
    resources = {
      subnet = {
        (each.key) = {
          id         = each.value.id
          arn        = each.value.arn

          cidr_block = each.value.cidr_block
          az         = each.value.availability_zone

          map_public_ip_on_launch        = each.value.map_public_ip_on_launch
          assign_ipv6_on_creation        = each.value.assign_ipv6_address_on_creation
          ipv6_cidr_block                = try(each.value.ipv6_cidr_block, null)

          tags = each.value.tags_all

          type = lookup(each.value, "type", null)
        }
      }
    }

    modules = [
      "core/network/subnet"
    ]

    version = "2025.11.12"
  }
}

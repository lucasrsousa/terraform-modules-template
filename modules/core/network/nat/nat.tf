resource "aws_nat_gateway" "this" {
  for_each = { for n in var.nats : n.name => n }

  allocation_id = each.value.allocation_id
  subnet_id     = each.value.subnet_id

  tags = merge(
    var.tags,
    { Name = each.key }
  )
}

module "inventory_item" {
  for_each = aws_nat_gateway.this

  source        = "../../utils/add_item_inventory"

  stack_id      = "${var.env}/modules/core/network/nat/${each.key}"
  resource_type = "nat_gateway"
  resource_name = each.key
  region        = var.aws_region

  metadata = {
    resources = {
      nat_gateway = {
        (each.key) = {
          id            = each.value.id
          public_ip     = each.value.public_ip
          allocation_id = each.value.allocation_id
          subnet_id     = each.value.subnet_id
          tags          = each.value.tags_all
        }
      }
    }

    modules = [
      "core/network/nat"
    ]

    version = "2025.11.12"
  }
}

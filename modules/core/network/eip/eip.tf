resource "aws_eip" "this" {
  for_each = var.eips

  domain = "vpc"

  tags = merge(
    var.tags,
    lookup(each.value, "tags", {}),
    { Name = each.key } 
  )
}

module "inventory_item" {
  for_each = var.eips

  source        = "../../utils/add_item_inventory"

  stack_id      = "${var.env}/modules/core/network/eip/${each.key}"
  resource_type = "eip"
  resource_name = each.key
  region        = var.aws_region

  metadata = {
    resources = {
      eip = {
        (each.key) = {
          id        = aws_eip.this[each.key].id
          public_ip = aws_eip.this[each.key].public_ip
          tags      = aws_eip.this[each.key].tags
        }
      }
    }

    modules = [
      "core/network/eip"
    ]

    version = "2025.11.12"
  }
}
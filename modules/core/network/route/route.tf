resource "aws_route_table" "this" {
  for_each = { for r in var.routes : r.name => r }

  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    { Name = each.key }
  )
}

resource "aws_route_table_association" "assoc" {
  for_each = merge([
    for route in var.routes : {
      for subnet in route.associations :
      "${route.name}.${subnet}" => {
        route_name = route.name
        subnet_id  = subnet
      }
    }
  ]...)

  subnet_id      = each.value.subnet_id
  route_table_id = aws_route_table.this[each.value.route_name].id
}

module "inventory_item" {
  for_each = aws_route_table.this

  source        = "../../utils/add_item_inventory"

  stack_id      = "${var.env}/modules/core/network/route_table/${each.key}"
  resource_type = "route_table"
  resource_name = each.key
  region        = var.aws_region

  metadata = {
    resources = {
      route_table = {
        (each.key) = {
          id     = each.value.id
          arn    = each.value.arn
          vpc_id = each.value.vpc_id

          tags   = each.value.tags_all

          associations = {
            for k, assoc in aws_route_table_association.assoc :
            k => {
              subnet_id = assoc.subnet_id
            } if assoc.route_table_id == each.value.id
          }
        }
      }
    }

    modules = [
      "core/network/route"
    ]

    version = "2025.11.12"
  }
}

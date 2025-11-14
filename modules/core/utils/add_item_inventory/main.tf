variable "stack_id" { type = string }
variable "region" { type = string }
variable "resource_type" { type = string }
variable "resource_name" { type = string }
variable "metadata" {
  description = "Arbitrary metadata to store with the inventory item."
  type = any
}

resource "aws_dynamodb_table_item" "entry" {
  table_name = "iac_inventory"
  hash_key   = "resource_name"
  range_key  = "stack_id"

  item = jsonencode({
    resource_name = { S = var.resource_name }
    stack_id      = { S = var.stack_id }
    resource_type = { S = var.resource_type }
    region        = { S = var.region }
    status        = { S = "active" }
    metadata      = { S = jsonencode(var.metadata) }
    updated_at    = { S = timestamp() }
  })
}

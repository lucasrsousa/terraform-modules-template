output "nat_metadata" {
  value = {
    for k, nat in aws_nat_gateway.this :
    k => {
      id         = nat.id
      subnet_id  = nat.subnet_id
      allocation_id = nat.allocation_id
      tags       = nat.tags
    }
  }
}

output "nat_ids" {
  value = { for k, nat in aws_nat_gateway.this : k => nat.id }
}
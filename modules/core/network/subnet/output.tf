output "subnet_ids" {
  description = "IDs das subnets criadas"
  value       = { for k, s in aws_subnet.this : k => s.id }
}

output "public_subnets" {
  description = "IDs das subnets públicas (se houver)"
  value       = {
    for k, s in aws_subnet.this : k => s.id if s.map_public_ip_on_launch
  }
}

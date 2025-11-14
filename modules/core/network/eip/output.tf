output "eip_metadata" {
  value = {
    for k, eip in aws_eip.this :
    k => {
      id   = eip.id
      ip   = eip.public_ip
      tags = eip.tags
    }
  }
}

output "eip_ids" {
  value = { for k, eip in aws_eip.this : k => eip.id }
}

output "eip_public_ip" {
  value = { for k, eip in aws_eip.this : k => eip.public_ip }
}
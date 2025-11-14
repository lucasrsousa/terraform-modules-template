output "oac_id" {
  description = "ID do Origin Access Control criado"
  value       = aws_cloudfront_origin_access_control.oac.id
}

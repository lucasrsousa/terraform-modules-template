output "bucket_id_criado" {
  description = "O nome (ID) do bucket S3 criado."
  value       = aws_s3_bucket.basic_bucket.id
}

output "bucket_arn_criado" {
  description = "O ARN do bucket S3."
  value       = aws_s3_bucket.basic_bucket.arn
}
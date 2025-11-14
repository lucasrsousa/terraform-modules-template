resource "aws_s3_bucket" "basic_bucket" {
  bucket = var.bucket_name
  
  # Impede deleção acidental se o bucket não estiver vazio (já estava no seu código)
  force_destroy = false 
}

# Bloqueia qualquer forma de acesso público ao bucket.
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.basic_bucket.id

  # Todas as opções setadas como true forçam o bloqueio total
  block_public_acls       = true 
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Define o controle de propriedade como 'BucketOwnerEnforced' (Padrão e recomendado pela AWS)
# Isso desabilita as ACLs e garante que apenas políticas de IAM/Bucket sejam usadas.
resource "aws_s3_bucket_ownership_controls" "ownership_control" {
  bucket = aws_s3_bucket.basic_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Garante que todos os objetos futuros sejam criptografados automaticamente (SSE-S3).
resource "aws_s3_bucket_server_side_encryption_configuration" "default_encryption" {
  bucket = aws_s3_bucket.basic_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # Equivalente ao SSE-S3
    }
  }
}

# Habilita o versionamento para proteger contra exclusões acidentais ou maliciosas.
# resource "aws_s3_bucket_versioning" "versioning" {
#   bucket = aws_s3_bucket.basic_bucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }
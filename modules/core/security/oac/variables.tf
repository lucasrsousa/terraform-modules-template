variable "aws_region" {
  description = "Região do S3"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Nome unico do bucket S3. Deve ser globalmente unico."
  type        = string
}

variable "tags" {
  description = "Tags adicionais para os recursos"
  type        = map(string)
  default     = {}
}
variable "bucket_name" {
  description = "Nome unico do bucket S3. Deve ser globalmente unico."
  type        = string
}

variable "tags" {
  description = "Tags adicionais para os recursos"
  type        = map(string)
  default     = {}
}
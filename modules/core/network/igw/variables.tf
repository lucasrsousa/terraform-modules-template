variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC associada"
}

variable "enable_ipv6_public_route" {
  description = "Define se a rota IPv6 pública (::/0) será criada."
  type        = bool
  default     = false # Padrão para desativado (opcional)
}

variable "public_route_table_ids" {
  description = "Lista de route tables públicas"
  type        = list(string)
}

variable "tags" {
  description = "Tags adicionais para os recursos"
  type        = map(string)
  default     = {}
}
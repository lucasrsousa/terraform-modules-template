variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "nome" {
  description = "Nome da VPC"
  type        = string
}

variable "cidr_block" {
  description = "CIDR Block"
  type        = string
}

variable "assign_generated_ipv6_cidr_block" {
  type    = bool
  default = false
  description = "Define se o IPv6 deve ser gerado automaticamente"
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "subnets" {
  description = "Lista ou mapa com as configurações das subnets"
  type        = map(any)
  default     = {}
}

variable "routes" {
  description = "Mapa das tabelas de rota"
  type        = map(any)
  default     = {}
}

variable "tags" {
  description = "Tags adicionais para os recursos"
  type        = map(string)
  default     = {}
}
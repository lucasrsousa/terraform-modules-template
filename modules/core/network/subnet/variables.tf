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
  description = "ID da VPC associada"
  type        = string
}

variable "subnets" {
  description = "Mapa de subnets a serem criadas"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    map_public_ip     = optional(bool)
  }))
}

variable "tags" {
  description = "Tags padrão aplicadas a todas as subnets"
  type        = map(string)
  default     = {}
}
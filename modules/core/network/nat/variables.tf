variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "nats" {
  description = "Lista de NAT Gateways"
  type = list(object({
    name           = string
    allocation_id  = string
    subnet_id      = string
  }))
}

variable "tags" {
  description = "Tags adicionais para os recursos"
  type        = map(string)
  default     = {}
}
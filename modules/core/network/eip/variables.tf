variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "Environment"
  type        = string
}

variable "eips" {
  description = "Lista de EIPs (por AZ ou finalidade)"
  type = map(object({
    tags = optional(map(string))
  }))
  default = {
    primary = {}
  }
}

variable "tags" {
  description = "Tags adicionais para os recursos"
  type        = map(string)
  default     = {}
}
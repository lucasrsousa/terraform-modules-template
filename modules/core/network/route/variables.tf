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

variable "routes" {
  type = list(object({
    name          = string
    associations  = list(string)
  }))
}

variable "tags" {
  description = "Tags adicionais para os recursos"
  type        = map(string)
  default     = {}
}
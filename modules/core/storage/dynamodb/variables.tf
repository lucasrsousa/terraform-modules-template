variable "table_name" {
  description = "Nome da tabela DynamoDB."
  type        = string
}

variable "hash_key" {
  description = "Chave de partição (Hash Key)."
  type        = string
}

variable "range_key" {
  description = "Chave de classificação (Range Key). Opcional."
  type        = string
  default     = null // Tornando opcional
}

variable "attributes" {
  description = "Lista de atributos para a tabela (Hash Key e Range Key devem estar inclusos)."
  type = list(object({
    name = string
    type = string
  }))
}

variable "billing_mode" {
  description = "Modo de cobrança (ex: PAY_PER_REQUEST ou PROVISIONED)."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "extra_tags" {
  description = "Tags adicionais a serem aplicadas à tabela."
  type        = map(string)
  default     = {}
}
resource "aws_dynamodb_table" "generic_table" {
  name           = var.table_name
  billing_mode   = var.billing_mode
  hash_key       = var.hash_key
  range_key      = var.range_key // Será null se não for passado

  # Itera sobre a lista de atributos fornecida
  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  # Se você não precisar de TTL (Time to Live) por padrão, pode removê-lo ou parametrizá-lo.
  # Mantendo o padrão do seu exemplo original, mas tornando o attribute_name configurável.
  ttl {
    attribute_name = "expires_at" # Pode ser parametrizado se necessário
    enabled        = false
  }

  tags = merge(
    {
      ManagedBy = "terraform"
    },
    var.extra_tags // Adiciona tags customizadas
  )
}
output "dynamodb_table_name" {
  description = "O nome da tabela DynamoDB criada."
  value       = aws_dynamodb_table.generic_table.name
}

output "dynamodb_table_arn" {
  description = "O ARN (Amazon Resource Name) da tabela DynamoDB."
  value       = aws_dynamodb_table.generic_table.arn
}

output "dynamodb_table_id" {
  description = "O ID da tabela DynamoDB (que é o mesmo que o nome)."
  value       = aws_dynamodb_table.generic_table.id
}
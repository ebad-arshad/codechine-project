output "frontend_instance" {
  value = aws_instance.frontend_instance
}

output "backend_instance" {
  value = aws_instance.backend_instance
}

output "database_instance" {
  value = aws_instance.database_instance
}
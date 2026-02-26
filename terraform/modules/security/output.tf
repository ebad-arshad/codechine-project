output "alb_sg" {
  value = aws_security_group.alb_sg
}

output "frontend_security_group" {
  value = aws_security_group.frontend_sg
}

output "backend_security_group" {
  value = aws_security_group.backend_sg
}

output "database_security_group" {
  value = aws_security_group.database_sg
}
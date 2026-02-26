output "vpc" {
  value = aws_vpc.vpc
}

output "public_subnet" {
  value = [aws_subnet.public_subnet_1, aws_subnet.public_subnet_2]
}

output "frontend_subnet" {
  value = aws_subnet.frontend_private_subnet
}

output "backend_subnet" {
  value = aws_subnet.backend_private_subnet
}

output "database_subnet" {
  value = aws_subnet.database_private_subnet
}
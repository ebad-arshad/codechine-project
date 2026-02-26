resource "aws_instance" "frontend_instance" {
  ami                    = "ami-019715e0d74f695be"
  instance_type          = "t3.micro"
  key_name               = "terraform"
  subnet_id              = var.frontend_subnet.id
  vpc_security_group_ids = [var.frontend_security_group.id]
  associate_public_ip_address = false

  user_data = templatefile("${path.module}/scripts/frontend.sh", {
    backend_private_ip = aws_instance.backend_instance.private_ip
    docker_username = var.docker_username
    image_tag = var.image_tag
  })

  depends_on = [ aws_instance.backend_instance ]

  tags = {
    Name        = "Frontend-Instance-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_instance" "backend_instance" {
  ami                    = "ami-019715e0d74f695be"
  instance_type          = "t3.micro"
  key_name               = "terraform"
  subnet_id              = var.backend_subnet.id
  vpc_security_group_ids = [var.backend_security_group.id]
  associate_public_ip_address = false

  user_data = templatefile("${path.module}/scripts/backend.sh", {
    db_private_ip = aws_instance.database_instance.private_ip
    mongodb_password      = var.mongodb_password
    docker_username = var.docker_username
    image_tag = var.image_tag
  })

  depends_on = [ aws_instance.database_instance ]

  tags = {
    Name        = "Backend-Instance-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_instance" "database_instance" {
  ami                    = "ami-019715e0d74f695be"
  instance_type          = "t3.small"
  key_name               = "terraform"
  subnet_id              = var.database_subnet.id
  vpc_security_group_ids = [var.database_security_group.id]
  associate_public_ip_address = false

  user_data = templatefile("${path.module}/scripts/database.sh", {
    mongodb_root_password = var.mongodb_root_password
    mongodb_password      = var.mongodb_password
  })

  tags = {
    Name        = "Database-Instance-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

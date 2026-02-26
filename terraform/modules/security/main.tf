resource "aws_security_group" "alb_sg" {
  name        = "ALB-SG-${terraform.workspace}"
  vpc_id      = var.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB-SG-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_security_group" "frontend_sg" {
  name   = "Frontend-SG-${terraform.workspace}"
  vpc_id = var.vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Frontend-SG-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_security_group" "backend_sg" {
  name   = "Backend-SG-${terraform.workspace}"
  vpc_id = var.vpc.id

  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Backend-SG-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_security_group" "database_sg" {
  name   = "Database-SG-${terraform.workspace}"
  vpc_id = var.vpc.id

  ingress {
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" #
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Database-SG-${terraform.workspace}"
    Environment = terraform.workspace
  }
}
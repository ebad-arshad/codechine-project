# -------------------VPC-------------------
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = {
    Name = "VPC-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

# -------------------Subnet-------------------
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-1a-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-1b-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_subnet" "frontend_private_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "Frontend-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_subnet" "backend_private_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.20.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "Backend-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_subnet" "database_private_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.30.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "Database-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

# -------------------EIP-------------------
resource "aws_eip" "nat_eip" {
  domain   = "vpc"

  tags = {
    Name = "EIP-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

# -------------------Internet Gateway-------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Internet-Gateway-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

# -------------------NAT Gateway-------------------
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "NAT-${terraform.workspace}"
    Environment = terraform.workspace
  }

  depends_on = [aws_internet_gateway.igw]
}

# -------------------Route Table-------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-RT-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Private-RT-${terraform.workspace}"
    Environment = terraform.workspace
  }
}

# -------------------Route Table Association-------------------

resource "aws_route_table_association" "public_1_assoc" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2_assoc" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_1_assoc" {
  subnet_id      = aws_subnet.frontend_private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_2_assoc" {
  subnet_id      = aws_subnet.backend_private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_3_assoc" {
  subnet_id      = aws_subnet.database_private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
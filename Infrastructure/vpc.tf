resource "aws_vpc" "ecommerce_vpc" {
  cidr_block = "10.240.0.0/16"  # Replace with your desired CIDR block

  tags = {
    Name = "ecommerce"
  }
}

resource "aws_nat_gateway" "ecommerce_nat" {
  vpc_id = aws_vpc.ecommerce_vpc.id

  tags = {
    Name = "EcommerceNATGateway"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.ecommerce_vpc.id
  cidr_block              = "10.240.1.0/24"  # Replace with your desired CIDR block
  availability_zone       = "ap-northeast-1a"  # Replace with your desired availability zone

  tags = {
    Name = "EcommercePublicSubnet"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.ecommerce_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ecommerce_nat.id
  }

  tags = {
    Name = "EcommercePublicRouteTable"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.ecommerce_vpc.id
  cidr_block              = "10.240.2.0/24"  # Replace with your desired CIDR block
  availability_zone       = "ap-northeast-1b"  # Replace with your desired availability zone

  tags = {
    Name = "EommercePrivateSubnet"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.ecommerce_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ecommerce_nat.id
  }

  tags = {
    Name = "EcommercePrivateRouteTable"
  }
}

resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route.id
}

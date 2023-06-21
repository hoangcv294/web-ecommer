#######################-Create VPC-#######################
resource "aws_vpc" "ecommerce_vpc" {
  cidr_block = "10.240.0.0/16" # Replace with your desired CIDR block

  tags = {
    Name = "${var.project}"
  }
}

#######################-Create internet gateway-#######################
resource "aws_internet_gateway" "ecommerce_igw" {
  vpc_id = aws_vpc.ecommerce_vpc.id
}

#######################-Create Public subnet-#######################
resource "aws_subnet" "public_subnet_a" {
  vpc_id     = aws_vpc.ecommerce_vpc.id
  cidr_block = "10.240.1.0/24" # Replace with your desired CIDR block
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "Public-Subnet"
  }
}

#######################-Create Public subnet-#######################
resource "aws_subnet" "public_subnet_b" {
  vpc_id     = aws_vpc.ecommerce_vpc.id
  cidr_block = "10.240.2.0/24" # Replace with your desired CIDR block
  availability_zone = "ap-southeast-1b"
  tags = {
    Name = "Public-Subnet"
  }
}

#######################-Create Public route table-#######################
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.ecommerce_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecommerce_igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

#######################-Allocate Route table with Public subnet-#######################
resource "aws_route_table_association" "public1" {
  subnet_id = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_rtb.id
}

#######################-Allocate Route table with Public subnet-#######################
resource "aws_route_table_association" "public2" {
  subnet_id = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_rtb.id
}

#######################-Create Private subnet-#######################
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.ecommerce_vpc.id
  cidr_block = "10.240.3.0/24" # Replace with your desired CIDR block
  availability_zone = "ap-southeast-1c"

  tags = {
    Name = "Private-Subnet"
  }
}

#######################-Create Private route table-#######################
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.ecommerce_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecommerce_igw.id
  }

  tags = {
    Name = "private-route-table"
  }
}

#######################-Allocate Route table with private subnet-#######################
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rtb.id
}
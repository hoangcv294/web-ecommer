#######################-Create SG Server-#######################
resource "aws_security_group" "private_server_sg" {
  name        = "${var.project}-Server"
  description = "Allow BH-ALB"

  vpc_id = aws_vpc.ecommerce_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.240.0.0/16"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.240.1.0/26"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private Security"
  }
}

#######################-Create SG ALB-#######################
resource "aws_security_group" "bastion_host_sg" {
  name        = "Bastion-Host-SG"
  description = "Method Connection"

  vpc_id = aws_vpc.ecommerce_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "Bastion-Host"
  }
}

#######################-Create SG ALB-#######################
resource "aws_security_group" "ecommerce_sg" {
  name        = "${var.project}-SG"
  description = "All Traffic"

  vpc_id = aws_vpc.ecommerce_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-SG"
  }
}
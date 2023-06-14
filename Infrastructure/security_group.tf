resource "aws_security_group" "ec2_sg" {
  name        = "EcommerceSecurityGroup"
  description = "Allow SSH"

  vpc_id = aws_vpc.ecommerce_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #Replace just one my IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EcommerceSecurityGroup"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "EcommerceSecurityGroup"
  description = "Allow SSH"

  vpc_id = aws_vpc.ecommerce_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #Replace just one my IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EcommerceSecurityGroup"
  }
}
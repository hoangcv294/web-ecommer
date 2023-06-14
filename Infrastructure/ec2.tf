resource "aws_instance" "apache_server" {
  ami           = "ami-0d739893974bd27d0"  # Replace with your desired AMI ID
  instance_type = "t2.micro"  # Replace with your desired instance type
  key_name      = "wordpress_key.pem"  # Replace with your SSH key pair name (if required)
  vpc           = [aws_vpc.ecommerce_vpc.id]
  subnet        = [aws_subnet.private_subnet.id]
  iam_instance_profile = [aws_iam_role.ecommerce_iam_role.name]
  tags = {
    Name = "ExampleInstance"
  }
}

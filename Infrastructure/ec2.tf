#######################-Create Server-#######################
resource "aws_instance" "apache_server" {
  ami           = "ami-076015d9e4b6b6a0b" # Replace with your desired AMI ID
  instance_type = "t2.micro"              # Replace with your desired instance type
  key_name      = "wp-server"             # Replace with your SSH key pair name (if required)
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = aws_subnet.private_subnet.id
  iam_instance_profile = aws_iam_instance_profile.e_instance_profile.name
  tags = {
    Name = "${var.project}-Server"
  }
}
#######################-Create EIP-#######################
resource "aws_eip" "ecommerce_eip" {
  instance = aws_instance.apache_server.id
  vpc      = true
}
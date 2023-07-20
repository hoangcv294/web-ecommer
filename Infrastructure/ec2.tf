#####################-Create Private Server-#######################
resource "aws_instance" "apache_server" {
  ami                    = "ami-039634ed9479f8fbf" # Replace with your desired AMI ID
  instance_type          = "t2.micro"              # Replace with your desired instance type
  key_name               = "Server"                # Replace with your SSH key pair name (if required)
  vpc_security_group_ids = [aws_security_group.private_server_sg.id]
  subnet_id              = aws_subnet.private_subnet.id
  iam_instance_profile   = aws_iam_instance_profile.e_instance_profile_1.name
  tags = {
    Name = "${var.project}-Server"
  }
}

####################-Create Bastion Host-#######################
resource "aws_instance" "bastion_host" {
  ami                    = "ami-06b79cf2aee0d5c92" # Replace with your desired AMI ID
  instance_type          = "t2.micro"              # Replace with your desired instance type
  key_name               = "BastionHost"           # Replace with your SSH key pair name (if required)
  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]
  subnet_id              = aws_subnet.public_subnet_a.id
  iam_instance_profile   = aws_iam_instance_profile.e_instance_profile_2.name
  tags = {
    Name = "Bastion-Host-Server"
  }
}

resource "aws_eip" "eip" {
  vpc      = true
  instance = aws_instance.bastion_host.id
}
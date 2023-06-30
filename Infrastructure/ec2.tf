######################-Create Server-#######################
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
######################-Create EIP-#######################
resource "aws_eip" "ecommerce_eip" {
  instance = aws_instance.apache_server.id
  vpc      = true
}

resource "aws_autoscaling_group" "e_autoscaling" {
  name                      = "${var.project}-AutoScalingGroup"
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 5
  vpc_zone_identifier       = [aws_subnet.private_subnet.id]
  launch_configuration      = aws_launch_configuration.my_launchconfig.name
  health_check_type         = "EC2"
  termination_policies      = ["OldestInstance"]
  wait_for_capacity_timeout = "10m"
}

resource "aws_launch_configuration" "my_launchconfig" {
  name                 = "${var.project}-LaunchConfiguration"
  image_id             = "ami-0a61816266d942ce3"
  instance_type        = "t2.micro"
  security_groups      = [aws_security_group.ec2_sg.id]
  key_name             = "wp-server"
  lifecycle {
    create_before_destroy = true
  }
}
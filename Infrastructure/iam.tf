
#######################-Create IAM Role-#######################
resource "aws_iam_role" "ecommerce_iam_role" {
  name = "${var.project}-SSMRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

#######################-Add SSM Permission-#######################
resource "aws_iam_role_policy_attachment" "ecommerce_SSM_policy" {
  role       = aws_iam_role.ecommerce_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#######################-Add S3 Permission-#######################
resource "aws_iam_role_policy_attachment" "ecommerce_S3_policy" {
  role       = aws_iam_role.ecommerce_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

#######################--Create IAM Instance Profile-#######################-
resource "aws_iam_instance_profile" "e_instance_profile" {
  name = "Ecommerce-SSMInstanceProfile"
  role = aws_iam_role.ecommerce_iam_role.name
}
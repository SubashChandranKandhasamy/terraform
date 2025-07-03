provider "aws" {
  region = var.aws_region
}

# IAM Role for EC2
resource "aws_iam_role" "app_role" {
  name = "webapp-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# IAM Policy (e.g., access to S3)
resource "aws_iam_policy" "app_policy" {
  name        = "webapp-policy"
  description = "Policy for web app to access S3"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "s3:GetObject",
        "s3:PutObject"
      ],
      Effect   = "Allow",
      Resource = "*"
    }]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.app_policy.arn
}

# Instance Profile for EC2
resource "aws_iam_instance_profile" "app_instance_profile" {
  name = "webapp-instance-profile"
  role = aws_iam_role.app_role.name
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.app_instance_profile.name
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "WebAppInstance"
  }

  # User data or other provisioning can go here
}

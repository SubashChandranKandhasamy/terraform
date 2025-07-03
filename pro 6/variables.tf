variable "aws_region" {
  default = "us-east-1"
}

variable "ami_id" {
  description = "AMI to use for EC2"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "Instance type"
}

variable "key_name" {
  description = "SSH key name"
}

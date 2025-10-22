variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro" # free tier compatible
}

variable "key_name" {
  type = string
  description = "Name of existing key pair in AWS (create in console or via aws cli). Replace before apply."
  default = "key-06-10-2025"
}

variable "allowed_cidr" {
  type    = string
  default = "0.0.0.0/0" # wide open for testing; replace with your IP for security
}

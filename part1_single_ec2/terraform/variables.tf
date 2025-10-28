variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "key_name" {
  type = string
  default = "key-06-10-2025" # replace with your key
}

variable "allowed_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

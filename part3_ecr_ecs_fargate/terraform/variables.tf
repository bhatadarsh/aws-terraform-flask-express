variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "aws_account_id" {
  description = "AWS account id"
  type        = string
  default     = "811264947819"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs (2 AZs)"
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "flask_ecr_repo" {
  description = "Name of flask ECR repo"
  type        = string
  default     = "flask-repo"
}

variable "express_ecr_repo" {
  description = "Name of express ECR repo"
  type        = string
  default     = "express-repo"
}

variable "service_desired_count" {
  description = "Desired count for ECS services"
  type        = number
  default     = 1
}

variable "flask_image" {
  description = "Full ECR image URI for flask (set after push)"
  type        = string
  default     = ""
}

variable "express_image" {
  description = "Full ECR image URI for express (set after push)"
  type        = string
  default     = ""
}

resource "aws_ecr_repository" "flask_repo" {
  name                 = var.flask_ecr_repo
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "Flask ECR Repo"
  }
}

resource "aws_ecr_repository" "express_repo" {
  name                 = var.express_ecr_repo
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "Express ECR Repo"
  }
}

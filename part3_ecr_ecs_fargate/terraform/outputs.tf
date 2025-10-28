output "alb_dns" {
  description = "Application Load Balancer DNS name"
  value       = aws_lb.flask_alb.dns_name
}

output "flask_ecr_repo_url" {
  description = "Flask ECR repository URL"
  value       = aws_ecr_repository.flask_repo.repository_url
}

output "express_ecr_repo_url" {
  description = "Express ECR repository URL"
  value       = aws_ecr_repository.express_repo.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "flask_service_name" {
  value = aws_ecs_service.flask_service.name
}

output "express_service_name" {
  value = aws_ecs_service.express_service.name
}

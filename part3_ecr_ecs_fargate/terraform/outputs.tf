#########################################
# ECS & ALB Outputs
#########################################

# ALB DNS Name
output "alb_dns" {
  description = "DNS name of the ALB"
  value       = aws_lb.app_lb.dns_name
}

# Flask Target Group ARN
output "flask_target_group_arn" {
  description = "ARN of Flask Target Group"
  value       = aws_lb_target_group.flask_tg.arn
}

# Express Target Group ARN
output "express_target_group_arn" {
  description = "ARN of Express Target Group"
  value       = aws_lb_target_group.express_tg.arn
}

# Flask Listener ARN
output "flask_listener_arn" {
  description = "ARN of Flask Listener"
  value       = aws_lb_listener.flask_listener.arn
}

# Express Listener ARN
output "express_listener_arn" {
  description = "ARN of Express Listener"
  value       = aws_lb_listener.express_listener.arn
}

# ALB Security Group ID
output "alb_sg_id" {
  description = "Security group ID for the ALB"
  value       = aws_security_group.alb_sg.id
}

# ECS Cluster Name
output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.main.name
}

# ECS Flask Service Name
output "flask_service_name" {
  description = "Flask ECS service name"
  value       = aws_ecs_service.flask_service.name
}

# ECS Express Service Name
output "express_service_name" {
  description = "Express ECS service name"
  value       = aws_ecs_service.express_service.name
}

# Flask ECR Repository URL
output "flask_ecr_repo_url" {
  description = "Flask ECR repository URL"
  value       = aws_ecr_repository.flask_repo.repository_url
}

# Express ECR Repository URL
output "express_ecr_repo_url" {
  description = "Express ECR repository URL"
  value       = aws_ecr_repository.express_repo.repository_url
}

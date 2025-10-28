#########################################
# ECS Cluster
#########################################

resource "aws_ecs_cluster" "main" {
  name = "part3-cluster"
}

#########################################
# Security Group for ECS Tasks
#########################################

resource "aws_security_group" "svc_sg" {
  name        = "ecs-service-sg"
  description = "Allow ALB to access ECS tasks"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow ALB to Flask service"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description = "Allow ALB to Express service"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-service-sg"
  }
}

#########################################
# Flask Task Definition
#########################################

resource "aws_ecs_task_definition" "flask_task" {
  family                   = "flask-task"
  network_mode              = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  cpu                       = 256
  memory                    = 512
  execution_role_arn        = aws_iam_role.ecs_task_exec_role.arn

  container_definitions = jsonencode([
    {
      name      = "flask"
      image     = "811264947819.dkr.ecr.ap-south-1.amazonaws.com/flask-repo:latest"
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

#########################################
# Express Task Definition
#########################################

resource "aws_ecs_task_definition" "express_task" {
  family                   = "express-task"
  network_mode              = "awsvpc"
  requires_compatibilities  = ["FARGATE"]
  cpu                       = 256
  memory                    = 512
  execution_role_arn        = aws_iam_role.ecs_task_exec_role.arn

  container_definitions = jsonencode([
    {
      name      = "express"
      image     = "811264947819.dkr.ecr.ap-south-1.amazonaws.com/express-repo:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

#########################################
# Flask ECS Service
#########################################

resource "aws_ecs_service" "flask_service" {
  name            = "flask-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.flask_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = true
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    security_groups  = [aws_security_group.svc_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.flask_tg.arn
    container_name   = "flask"
    container_port   = 5000
  }

  depends_on = [aws_lb_listener.flask_listener]
}

#########################################
# Express ECS Service
#########################################

resource "aws_ecs_service" "express_service" {
  name            = "express-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.express_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = true
    subnets          = [aws_subnet.public_a.id, aws_subnet.public_b.id]
    security_groups  = [aws_security_group.svc_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.express_tg.arn
    container_name   = "express"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.express_listener]
}

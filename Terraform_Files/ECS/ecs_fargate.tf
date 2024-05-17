# Retrieve the default VPC
data "aws_vpc" "default" {
  default = true
}

# Retrieve subnets of the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Create a security group to allow port 80
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow inbound HTTP traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Retrieve the latest image digest from ECR
data "aws_ecr_image" "latest" {
  repository_name = var.ecr_repo_name
  most_recent     = true
}

# Create an ECS cluster for the Node.js application
resource "aws_ecs_cluster" "nodejs_app_cluster" {
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# Define capacity providers for the ECS cluster
resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.nodejs_app_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

# Define a task definition for the ECS service
resource "aws_ecs_task_definition" "task" {
  family                   = "nodejs-app-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  container_definitions    = <<TASK_DEFINITION
[
  {
    "name": "nodejs-app-container",
    "image": "${data.aws_ecr_image.latest.image_uri}",
    "cpu": 1024,
    "memory": 2048,
    "essential": true
  }
]
TASK_DEFINITION
}

# Define an ECS service for the Node.js application
resource "aws_ecs_service" "service" {
  name            = "nodejs-service"
  cluster         = aws_ecs_cluster.nodejs_app_cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  depends_on      = [aws_iam_role.ecsTaskExecutionRole]

  # Network configuration for the service
  network_configuration {
    subnets         = data.aws_subnets.default.ids
    security_groups = [aws_security_group.allow_http.id]
    assign_public_ip = true
  }
}

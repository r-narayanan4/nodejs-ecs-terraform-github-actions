# Output for ECS cluster name
output "ecs_cluster_name" {
  value = aws_ecs_cluster.nodejs_app_cluster.name
}

# Output for ECR image digest
output "ecr_image_digest" {
  value = data.aws_ecr_image.latest.image_digest
}

# Output for ECS cluster ARN
output "ecs_cluster_arn" {
  value = aws_ecs_cluster.nodejs_app_cluster.arn
}

# # Output for ECS service public IP address
# output "ecs_service_public_ip" {
#   value = aws_ecs_service.service.network_configuration[0].public_ip
# }

# Output for IAM role name for ECS task execution
output "ecs_task_execution_role_name" {
  value = aws_iam_role.ecsTaskExecutionRole.name
}

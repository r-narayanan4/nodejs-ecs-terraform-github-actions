# Define IAM role for ECS task execution
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    "Version"   : "2012-10-17",
    "Statement" : [
      {
        "Effect"    : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action"    : "sts:AssumeRole"
      }
    ]
  })
}

# Define IAM policy for ECS task execution role
resource "aws_iam_policy" "AmazonECSTaskExecutionRolePolicy" {
  name   = "AmazonECSTaskExecutionRolePolicy"
  policy = jsonencode({
    "Version"   : "2012-10-17",
    "Statement" : [
      {
        "Effect"   : "Allow",
        "Action"   : [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Attach IAM policy to ECS task execution role
resource "aws_iam_role_policy_attachment" "AmazonECSTaskExecutionRolePolicyAttachment" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn
}

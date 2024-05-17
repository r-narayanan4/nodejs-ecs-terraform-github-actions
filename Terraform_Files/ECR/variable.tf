# variables.tf

variable "aws_access_key" {
    description = "The IAM public access key"
}

variable "aws_secret_key" {
    description = "IAM secret access key"
}

variable "aws_region" {
    description = "The AWS region things are created in"
}


# ECR Variables

variable "ecr_repo_name" {
    description = "ecr repo name"
    default = "nodejs_appplication_repo"
}

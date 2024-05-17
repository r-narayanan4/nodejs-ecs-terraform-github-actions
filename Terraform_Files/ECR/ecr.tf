# Create an ECR repository for the Node.js application
resource "aws_ecr_repository" "nodejs_app_repo" {
    # Repository name
    name = var.ecr_repo_name

    # Force delete the repository
    force_delete = true

    # Enable image scanning on push
    image_scanning_configuration {
        scan_on_push = true
    }

    # Tags for the repository
    tags = {
        Name = "nodejs-app"
    }
}

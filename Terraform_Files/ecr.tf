# resource "aws_ecr_repository" "nodejs_app_repo" {
#     name = var.ecr_repo_name
#     force_delete = true

#     image_scanning_configuration {
#         scan_on_push = true
#     }

#     tags = {
#         Name = "nodejs-app"
#     }
# }

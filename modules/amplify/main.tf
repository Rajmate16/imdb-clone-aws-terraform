resource "aws_amplify_app" "main" {
  name         = "${var.project_name}-${var.environment}"
  repository   = var.frontend_repository
  access_token = var.github_access_token

  # Auto Branch Creation
  enable_auto_branch_creation = true
  enable_branch_auto_build    = true
  enable_branch_auto_deletion = true
  auto_branch_creation_patterns = [
    "*",
    "*/**",
  ]

  # Build Specification
  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  # Environment variables
  environment_variables = {
    REACT_APP_API_URL = var.backend_api_url
    NODE_ENV          = var.environment
  }

  # Custom rules for single-page application
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|ttf|map|json)$)([^.]+$)/>"
    status = "200"
    target = "/index.html"
  }
}

# Create a branch for the main branch
resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.main.id
  branch_name = "main"
  framework   = "React"
  stage       = var.environment

  environment_variables = {
    REACT_APP_API_URL = var.backend_api_url
    NODE_ENV          = var.environment
  }
}

# Create a branch for the development branch if environment is not prod
resource "aws_amplify_branch" "develop" {
  count       = var.environment != "prod" ? 1 : 0
  app_id      = aws_amplify_app.main.id
  branch_name = "develop"
  framework   = "React"
  stage       = "development"

  environment_variables = {
    REACT_APP_API_URL = var.backend_api_url
    NODE_ENV          = "development"
  }
}

# Create a domain association if domain name is provided
resource "aws_amplify_domain_association" "main" {
  count       = var.domain_name != "" ? 1 : 0
  app_id      = aws_amplify_app.main.id
  domain_name = var.domain_name

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = ""
  }

  sub_domain {
    branch_name = var.environment != "prod" ? aws_amplify_branch.develop[0].branch_name : aws_amplify_branch.main.branch_name
    prefix      = var.environment != "prod" ? "dev" : "www"
  }
}
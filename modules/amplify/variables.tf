variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "frontend_repository" {
  description = "GitHub repository URL for the frontend code"
  type        = string
}

variable "backend_api_url" {
  description = "URL of the backend API"
  type        = string
}

variable "github_access_token" {
  description = "GitHub personal access token for Amplify to access the repository"
  type        = string
  sensitive   = true
  default     = ""
}

variable "domain_name" {
  description = "Domain name for the Amplify app"
  type        = string
  default     = ""
}
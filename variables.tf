variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "imdb-clone"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password for the database (leave empty to generate a random one)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "imdbclone"
}

variable "db_instance_class" {
  description = "Instance class for the RDS database"
  type        = string
  default     = "db.t3.micro"
}

variable "eb_instance_type" {
  description = "Instance type for Elastic Beanstalk"
  type        = string
  default     = "t3.micro"
}

variable "frontend_repository" {
  description = "GitHub repository URL for the frontend code"
  type        = string
  default     = "https://github.com/cybagedevops/imdb-clone-frontend"
}

variable "backend_repository" {
  description = "GitHub repository URL for the backend code"
  type        = string
  default     = "https://github.com/cybagedevops/imdb-clone-backend"
}
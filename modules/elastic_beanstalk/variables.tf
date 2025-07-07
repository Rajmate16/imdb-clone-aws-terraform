variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs of the private subnets for the Elastic Beanstalk instances"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "IDs of the public subnets for the Elastic Beanstalk load balancer"
  type        = list(string)
}

variable "instance_type" {
  description = "Instance type for Elastic Beanstalk"
  type        = string
  default     = "t3.micro"
}

variable "backend_repository" {
  description = "GitHub repository URL for the backend code"
  type        = string
}

variable "db_endpoint" {
  description = "Endpoint of the RDS database"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Username for the database"
  type        = string
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

variable "ssl_certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS"
  type        = string
  default     = ""
}
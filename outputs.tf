output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "db_endpoint" {
  description = "Endpoint of the RDS database"
  value       = module.rds.db_endpoint
}

output "db_name" {
  description = "Name of the database"
  value       = var.db_name
}

output "backend_url" {
  description = "URL of the backend API"
  value       = module.elastic_beanstalk.api_endpoint
}

output "frontend_url" {
  description = "URL of the frontend application"
  value       = module.amplify.app_url
}

output "db_credentials_secret_arn" {
  description = "ARN of the secret containing database credentials"
  value       = aws_secretsmanager_secret.db_credentials.arn
}
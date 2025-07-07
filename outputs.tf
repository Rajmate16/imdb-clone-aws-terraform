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

output "database_endpoint" {
  description = "Endpoint of the RDS database"
  value       = module.rds.db_endpoint
}

output "database_name" {
  description = "Name of the database"
  value       = module.rds.db_name
}

output "database_username" {
  description = "Username for the database"
  value       = module.rds.db_username
}

output "database_secret_arn" {
  description = "ARN of the Secrets Manager secret containing database credentials"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "backend_api_url" {
  description = "URL of the backend API"
  value       = "https://${module.elastic_beanstalk.api_endpoint}"
}

output "backend_environment_name" {
  description = "Name of the Elastic Beanstalk environment"
  value       = module.elastic_beanstalk.environment_name
}

output "frontend_url" {
  description = "URL of the frontend application"
  value       = module.amplify.production_url
}

output "frontend_development_url" {
  description = "URL of the frontend development environment"
  value       = module.amplify.development_url
}

output "amplify_app_id" {
  description = "ID of the Amplify app"
  value       = module.amplify.app_id
}

output "amplify_default_domain" {
  description = "Default domain for the Amplify app"
  value       = module.amplify.default_domain
}
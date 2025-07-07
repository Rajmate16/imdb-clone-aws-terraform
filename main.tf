provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "imdb-clone"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}

# Create a random string for password generation if needed
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Store database credentials in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "${var.project_name}-${var.environment}-db-credentials"
  description = "Database credentials for IMDB Clone application"
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password != "" ? var.db_password : random_password.db_password.result
  })
}

# Create VPC and networking components
module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  azs          = var.availability_zones
}

# Create RDS database instance
module "rds" {
  source = "./modules/rds"

  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  db_username     = var.db_username
  db_password     = var.db_password != "" ? var.db_password : random_password.db_password.result
  db_name         = var.db_name
  db_instance_class = var.db_instance_class
}

# Create Elastic Beanstalk environment for backend
module "elastic_beanstalk" {
  source = "./modules/elastic_beanstalk"

  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  public_subnet_ids = module.vpc.public_subnet_ids
  instance_type   = var.eb_instance_type
  backend_repository = var.backend_repository
  db_endpoint     = module.rds.db_endpoint
  db_name         = var.db_name
  db_username     = var.db_username
  db_password     = var.db_password != "" ? var.db_password : random_password.db_password.result
}

# Create Amplify app for frontend
module "amplify" {
  source = "./modules/amplify"

  project_name    = var.project_name
  environment     = var.environment
  frontend_repository = var.frontend_repository
  backend_api_url = module.elastic_beanstalk.api_endpoint
}
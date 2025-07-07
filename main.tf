provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  
  # Uncomment this block to use a remote backend for state storage
  # backend "s3" {
  #   bucket         = "imdb-clone-terraform-state"
  #   key            = "terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "imdb-clone-terraform-locks"
  # }
}

# Generate a random password for the database if not provided
resource "random_password" "db_password" {
  count   = var.db_password == "" ? 1 : 0
  length  = 16
  special = false
}

locals {
  db_password = var.db_password != "" ? var.db_password : random_password.db_password[0].result
  project_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# VPC Module
module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  azs          = var.availability_zones
  tags         = local.project_tags
}

# Security Groups
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Security group for RDS database"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.beanstalk.id]
    description     = "Allow MySQL access from Elastic Beanstalk"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    local.project_tags,
    {
      Name = "${var.project_name}-${var.environment}-rds-sg"
    }
  )
}

resource "aws_security_group" "beanstalk" {
  name        = "${var.project_name}-${var.environment}-beanstalk-sg"
  description = "Security group for Elastic Beanstalk instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "Allow HTTP traffic"
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "Allow HTTPS traffic"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    local.project_tags,
    {
      Name = "${var.project_name}-${var.environment}-beanstalk-sg"
    }
  )
}

# RDS Module
module "rds" {
  source            = "./modules/rds"
  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnet_ids
  security_group_id = aws_security_group.rds.id
  db_username       = var.db_username
  db_password       = local.db_password
  db_name           = var.db_name
  db_instance_class = var.db_instance_class
  allocated_storage = var.db_allocated_storage
}

# Elastic Beanstalk Module
module "elastic_beanstalk" {
  source            = "./modules/elastic_beanstalk"
  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnet_ids
  public_subnet_ids = module.vpc.public_subnet_ids
  instance_type     = var.beanstalk_instance_type
  backend_repository = var.backend_repository
  db_endpoint       = module.rds.db_endpoint
  db_name           = module.rds.db_name
  db_username       = module.rds.db_username
  db_password       = local.db_password
  ssl_certificate_arn = var.ssl_certificate_arn
}

# Amplify Module
module "amplify" {
  source             = "./modules/amplify"
  project_name       = var.project_name
  environment        = var.environment
  frontend_repository = var.frontend_repository
  backend_api_url    = "https://${module.elastic_beanstalk.api_endpoint}"
  github_access_token = var.github_access_token
  domain_name        = var.domain_name
}

# Store database credentials in AWS Secrets Manager
resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "${var.project_name}-${var.environment}-db-credentials"
  description = "Database credentials for IMDB Clone application"
  
  tags = local.project_tags
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = local.db_password
    engine   = "mysql"
    host     = module.rds.db_endpoint
    port     = 3306
    dbname   = module.rds.db_name
  })
}
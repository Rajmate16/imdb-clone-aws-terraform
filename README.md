# IMDB Clone AWS Terraform Infrastructure

This repository contains Terraform code to deploy the IMDB Clone application on AWS infrastructure.

## Architecture

The infrastructure deploys:

- **Frontend**: React application hosted on AWS Amplify
- **Backend**: Spring Boot application deployed on AWS Elastic Beanstalk
- **Database**: RDS MySQL instance for persistent storage
- **Networking**: VPC, subnets, security groups, and other networking components
- **CI/CD**: AWS CodePipeline for continuous deployment

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform v1.0.0 or newer
- Git

## Repository Structure

```
.
├── README.md
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Input variables
├── outputs.tf              # Output values
├── terraform.tfvars.example # Example variable values
├── modules/
│   ├── vpc/                # VPC and networking resources
│   ├── rds/                # Database resources
│   ├── elastic_beanstalk/  # Backend application resources
│   └── amplify/            # Frontend application resources
└── .github/
    └── workflows/          # GitHub Actions workflows
```

## Getting Started

1. Clone this repository:
   ```
   git clone https://github.com/cybagedevops/imdb-clone-aws-terraform.git
   cd imdb-clone-aws-terraform
   ```

2. Create a `terraform.tfvars` file based on the example:
   ```
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your specific values
   ```

3. Initialize Terraform:
   ```
   terraform init
   ```

4. Plan the deployment:
   ```
   terraform plan
   ```

5. Apply the configuration:
   ```
   terraform apply
   ```

## Configuration

The following variables can be configured in your `terraform.tfvars` file:

- `aws_region`: AWS region to deploy resources
- `environment`: Environment name (e.g., dev, staging, prod)
- `vpc_cidr`: CIDR block for the VPC
- `db_username`: Database username
- `db_password`: Database password
- `frontend_repository`: GitHub repository URL for the frontend code
- `backend_repository`: GitHub repository URL for the backend code

## Outputs

After successful deployment, Terraform will output:

- Frontend URL
- Backend API URL
- Database endpoint

## Cleanup

To destroy all resources created by Terraform:

```
terraform destroy
```

## Security Considerations

- Database credentials are stored in AWS Secrets Manager
- All traffic is encrypted in transit using TLS
- Security groups restrict access to resources
- IAM roles follow the principle of least privilege
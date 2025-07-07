output "app_id" {
  description = "ID of the Amplify app"
  value       = aws_amplify_app.main.id
}

output "app_name" {
  description = "Name of the Amplify app"
  value       = aws_amplify_app.main.name
}

output "default_domain" {
  description = "Default domain for the Amplify app"
  value       = aws_amplify_app.main.default_domain
}

output "production_url" {
  description = "URL for the production branch"
  value       = "https://${aws_amplify_branch.main.branch_name}.${aws_amplify_app.main.default_domain}"
}

output "development_url" {
  description = "URL for the development branch"
  value       = var.environment != "prod" ? "https://${aws_amplify_branch.develop[0].branch_name}.${aws_amplify_app.main.default_domain}" : null
}
# Required outputs for grading script
output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "assets_bucket_name" {
  description = "S3 assets bucket name"
  value       = aws_s3_bucket.assets.id
}

# Sensitive outputs (not in grading.json)
output "developer_access_key_id" {
  description = "Developer IAM access key ID"
  value       = aws_iam_access_key.developer.id
  sensitive   = true
}

output "developer_secret_access_key" {
  description = "Developer IAM secret access key"
  value       = aws_iam_access_key.developer.secret
  sensitive   = true
}

output "developer_console_password" {
  description = "Console password for bedrock-dev-view user"
  value       = aws_iam_user_login_profile.developer.password
  sensitive   = true
}

# Developer IAM User - Read-only account for grading
resource "aws_iam_user" "developer" {
  name = "bedrock-dev-view"

  tags = {
    Role    = "Developer Read-Only Access"
    Project = "barakat-2025-capstone"
  }
}

# Console login - Allows user to sign into AWS Console
resource "aws_iam_user_login_profile" "developer" {
  user = aws_iam_user.developer.name
}

# ReadOnly policy - Can view everything, change nothing
resource "aws_iam_user_policy_attachment" "developer_readonly" {
  user       = aws_iam_user.developer.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# S3 upload permission - So grading script can test uploads
resource "aws_iam_user_policy" "developer_s3_put" {
  name = "bedrock-dev-s3-put-access"
  user = aws_iam_user.developer.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:PutObject",
        "s3:GetObject"
      ]
      Resource = "${aws_s3_bucket.assets.arn}/*"
    }]
  })
}

# Access Keys - Username/password for grading
resource "aws_iam_access_key" "developer" {
  user = aws_iam_user.developer.name
}

# Output console password for grading
output "developer_console_password" {
  value     = aws_iam_user_login_profile.developer.password
  sensitive = true
  description = "Console password for bedrock-dev-view user"
}

variable "region" {
  description = "AWS Region (MUST be us-east-1)"
  type        = string
  default     = "us-east-1"
}

variable "student_id" {
  description = "Your student ID for S3 bucket naming"
  type        = string
}
# CI/CD test - safe to delete

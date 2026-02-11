terraform {
  backend "s3" {
    bucket         = "bedrock-terraform-state-altsoe0250985"
    key            = "bedrock/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "bedrock-terraform-locks"
    encrypt        = true
  }
}

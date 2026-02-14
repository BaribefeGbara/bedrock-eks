terraform {
  backend "s3" {
    bucket = "bedrock-terraform-state-altsoe0250985"
    key    = "terraform.tfstate"
    region = "us-east-1"
    
    use_lockfile = true
  }
}

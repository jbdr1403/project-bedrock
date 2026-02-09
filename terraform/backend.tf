terraform {
  backend "s3" {
    bucket         = "project-bedrock-tf-state-539368884656"
    key            = "bedrock/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}


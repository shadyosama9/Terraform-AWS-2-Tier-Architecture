terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.40.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-bucket-2024"
    key            = "Terra-State/backend/terrform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "Terra-Lock"
  }
}

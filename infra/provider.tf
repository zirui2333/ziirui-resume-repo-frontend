
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9.0"
    }
  }

  backend "s3" {
    bucket = "tfbackend-for-resume"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}



terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "mybucket-terraform-hussain"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}
provider "aws" {
  region  = "us-west-2"
}
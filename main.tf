terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.54.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = "kenji-test"

}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
  profile = "kenji-test"
}
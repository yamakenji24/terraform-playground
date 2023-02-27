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
  alias   = "ap-northeast-1"
  region  = "ap-northeast-1"
  profile = "kenji-test"
}
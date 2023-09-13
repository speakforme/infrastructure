provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.45.0"
  profile = "speakforme"
}

provider "aws" {
  alias   = "mumbai"
  region  = "ap-south-1"
  version = "~> 2.45.0"
  profile = "speakforme"
}

terraform {
  required_version = "~> v0.12.12"

  backend "s3" {
    bucket  = "speakforme-infrastructure"
    key     = "terraform.tfstate"
    region  = "ap-south-1"
    profile = "speakforme"
    encrypt = "true"
  }
}

variable "region" {
  description = "AWS region"
  default     = "eu-west-1"
}

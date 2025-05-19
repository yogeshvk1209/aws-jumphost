########################## provider ##################################
provider "aws" {
  region = "us-west-2" # Change to your preferred AWS region
}
########################## provider ##################################
########################## terraform #################################
terraform {
  required_providers {
    aws = "~> 5.90.0"
  }
  required_version = "= 1.12.0"
}
########################## terraform #################################

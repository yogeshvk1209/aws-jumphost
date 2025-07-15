########################## variables ##################################
variable "availability_zone" {
  description = "The availability zone to deploy resources in"
  type        = string
  default     = null # Will use the first available AZ if not specified
}
########################## variables ##################################
########################## provider ##################################
provider "aws" {
  region = "us-east-1" # Change to your preferred AWS region
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

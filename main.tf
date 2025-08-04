########################## variables ##################################
variable "availability_zone" {
  description = "The availability zone to deploy resources in"
  type        = string
  default     = null # Will use the first available AZ if not specified
}

variable "userdata_script" {
  description = "The userdata script file to use for EC2 instance initialization"
  type        = string
  default     = "userdata.sh"
  validation {
    condition     = contains(["userdata.sh", "userdata_mcp.sh", "userdata_ollama.sh", "userdata_ollama_mcp.sh"], var.userdata_script)
    error_message = "The userdata_script must be either 'userdata.sh' or 'userdata_mcp.sh'."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t4g.medium"
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 30
  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 16384
    error_message = "Root volume size must be between 8 GB and 16384 GB."
  }
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

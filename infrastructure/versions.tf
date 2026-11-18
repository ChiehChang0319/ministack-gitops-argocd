#Terraform CLI版本和使用Provider版本
terraform {
  # 決定 Terraform CLI version
  required_version = ">= 1.6.0"

  # 決定 Provider version
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

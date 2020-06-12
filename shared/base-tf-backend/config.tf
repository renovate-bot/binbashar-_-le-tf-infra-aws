#=============================#
# AWS Provider Settings       #
#=============================#
provider "aws" {
  version                 = "~> 2.63"
  region                  = var.region
  profile                 = var.profile
  shared_credentials_file = "~/.aws/bb-le/config"
}

terraform {
  required_version = ">= 0.12.24"
}

provider "null" {
  version = "~> 2.1"
}

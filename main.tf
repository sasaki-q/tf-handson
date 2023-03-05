provider "aws" {
  region  = var.region
  profile = var.profile
}

variable "region" {}
variable "profile" {}

module "my-vpc-module" {
  source = "./modules/vpc"
}

module "my-iam-module" {
  source = "./modules/iam"
}

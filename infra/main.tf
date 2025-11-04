provider "aws" {
  region     = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "" 
    key    = ""
    region = ""
    use_lockfile = ""
    encrypt = ""
  }
}

module "vpc" {
 source = "./vpc" 
 vpc_cidr = local.vpc_cidr
 public_cidr = local.public_cidr
 private_cidr = local.private_cidr
}

terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = var.region
  profile = "iamadmin-general"
}


module "networking" {
  source                        = "./module/networking"
  vpc_id                        = module.networking.jen_vpc_id
  availability_zones            = var.availability_zones
  subnet_cidr                   = var.subnet_cidr
  subnet_id                     = module.networking.jen_subnet_id
  ami                           = var.ami
  ec2_id                        = module.ec2_instance.jen_ec2_id


}


module "ec2_instance" {
    source                      = "./module/ec2_instance"
    key_name                    = var.key_name
    subnet_id                   = module.networking.jen_subnet_id
    ami                         = var.ami
    vpc_id                      = module.networking.jen_vpc_id
    availability_zones          = var.availability_zones
    subnet_cidr                 = var.subnet_cidr
    vpc_security_group_ids      = ["module.ec2_instance.security_group_public"]
    ec2_id                      = module.ec2_instance.jen_ec2_id
}


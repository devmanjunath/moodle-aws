locals {
  public_subnets = {
    "ap-south-2a" : "10.0.1.0/24",
    "ap-south-2b" : "10.0.2.0/24",
    "ap-south-2c" : "10.0.3.0/24"
  }
  private_subnets = {
    "ap-south-2a" : "10.0.4.0/24",
    "ap-south-2b" : "10.0.5.0/24",
    "ap-south-2c" : "10.0.6.0/24"
  }
}

module "network" {
  source          = "./modules/network"
  name            = "Terraform VPC"
  description     = "VPC For Test Drive Powered By Moodle"
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
}

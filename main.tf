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
  name            = "Test-Drive VPC"
  description     = "VPC For Test Drive Powered By Moodle"
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
}

module "efs" {
  source           = "./modules/efs"
  name             = "Test-Drive FS"
  subnets_to_mount = module.network.public_subnets
  security_group   = [module.network.allow_nfs_sg]
}

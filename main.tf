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
  name            = var.project
  description     = "VPC For Test Drive Powered By Moodle"
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
}

module "efs" {
  depends_on       = [module.network]
  source           = "./modules/efs"
  name             = var.project
  subnets_to_mount = module.network.public_subnets
  security_group   = [module.network.allow_nfs_sg]
}

module "ecs" {
  depends_on       = [module.network]
  source           = "./modules/ecs"
  name             = var.project
  vpc_id           = module.network.vpc_id
  container_config = var.container_config
  subnets          = module.network.public_subnets
  security_group = [
    module.network.allow_ssh_sg,
    module.network.allow_nfs_sg,
    module.network.allow_web_sg,
    module.network.allow_ecs_sg
  ]
}

module "rds" {
  source  = "./modules/rds"
  name    = var.project
  vpc_id  = module.network.vpc_id
  subnets = module.network.public_subnets
  security_group = [
    module.network.allow_ssh_sg,
    module.network.allow_nfs_sg,
    module.network.allow_web_sg,
    module.network.allow_ecs_sg
  ]
}

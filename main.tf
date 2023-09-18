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

module "acm" {
  source = "./modules/acm"
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

module "load_balancer" {
  depends_on      = [module.network]
  source          = "./modules/load_balancer"
  name            = var.project
  acm_arn         = module.acm.acm_arn
  vpc_id          = module.network.vpc_id
  security_groups = [module.network.allow_web_sg]
  subnets         = module.network.public_subnets
}

module "ecs" {
  depends_on       = [module.network, module.efs, module.rds, module.cache, module.load_balancer]
  source           = "./modules/ecs"
  name             = var.project
  vpc_id           = module.network.vpc_id
  container_config = var.container_config
  target_group_arn = module.load_balancer.target_group_arn
  container_environments = {
    MOODLE_HOST              = module.load_balancer.target_group_arn
    MOODLE_CACHE_HOST        = module.cache.cache_endpoint
    MOODLE_DATABASE_NAME     = "moodle"
    MOODLE_DATABASE_PASSWORD = module.rds.db_password
    MOODLE_DATABASE_SERVER   = module.rds.db_endpoint
    MOODLE_DATABASE_USERNAME = module.rds.db_username
  }
  subnets = module.network.public_subnets
  efs_id  = module.efs.efs_id
  security_group = [
    module.network.allow_ssh_sg,
    module.network.allow_nfs_sg,
    module.network.allow_web_sg,
  ]
}

module "rds" {
  source  = "./modules/rds"
  name    = var.project
  vpc_id  = module.network.vpc_id
  subnets = module.network.public_subnets
  security_group = [
    module.network.allow_mysql,
  ]
}

module "cache" {
  source  = "./modules/cache"
  name    = var.project
  subnets = module.network.public_subnets
  security_group = [
    module.network.allow_memcached,
  ]
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      terraform = true
      project   = var.project
    }
  }
}

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

module "acm" {
  source      = "./modules/acm"
  domain_name = "cloudbreathe.in"
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

module "route53" {
  depends_on                = [module.load_balancer]
  source                    = "./modules/route53"
  domain_name               = "cloudbreathe.in"
  acm_arn                   = module.acm.acm_arn
  dns_name                  = module.load_balancer.dns_name
  zone_id                   = module.load_balancer.zone_id
  domain_validation_options = module.acm.domain_validation_options
}

module "efs" {
  depends_on       = [module.network]
  source           = "./modules/efs"
  name             = var.project
  subnets_to_mount = module.network.public_subnets
  security_group   = [module.network.allow_nfs_sg]
}

module "rds" {
  depends_on = [module.network]
  source     = "./modules/rds"
  name       = var.project
  vpc_id     = module.network.vpc_id
  subnets    = module.network.public_subnets
  security_group = [
    module.network.allow_mysql,
  ]
}

module "cache" {
  depends_on = [module.network]
  source     = "./modules/cache"
  name       = var.project
  subnets    = module.network.public_subnets
  security_group = [
    module.network.allow_memcached,
  ]
}

module "ecs" {
  depends_on           = [module.network, module.efs, module.rds, module.cache, module.load_balancer]
  source               = "./modules/ecs"
  name                 = var.project
  region               = var.region
  vpc_id               = module.network.vpc_id
  container_config     = var.container_config
  efs_arn              = module.efs.fs_arn
  efs_access_point_arn = module.efs.access_point_arn
  efs_access_point_id  = module.efs.access_point_id
  target_group_arn     = module.load_balancer.target_group_arn
  container_environments = {
    MOODLE_HOST              = "https://cloudbreathe.in"
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

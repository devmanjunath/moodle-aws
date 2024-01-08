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
    "${var.region}a" : "10.0.1.0/24",
    "${var.region}b" : "10.0.2.0/24"
    "${var.region}c" : "10.0.3.0/24"
  }
  private_subnets = {
    "${var.region}a" : "10.0.4.0/24",
    "${var.region}b" : "10.0.5.0/24",
    "${var.region}c" : "10.0.6.0/24"
  }
  instance_map = {
    100  = 2
    250  = 3
    500  = 6
    1000 = 12
    2000 = 24
    3000 = 36
    4000 = 48
    5000 = 60
  }
}

module "network" {
  source          = "./modules/network"
  name            = var.project
  environment     = var.environment
  description     = "VPC For Test Drive Powered By Moodle"
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
}

module "acm" {
  source      = "./modules/acm"
  domain_name = var.domain_name
}

module "route53" {
  depends_on                = [module.acm]
  source                    = "./modules/route53"
  domain_name               = var.domain_name
  acm_arn                   = module.acm.acm_arn
  domain_validation_options = module.acm.domain_validation_options
}

module "load_balancer" {
  depends_on      = [module.network, module.acm]
  count           = var.environment == "prod" ? 1 : 0
  source          = "./modules/load_balancer"
  name            = var.project
  domain_name     = "test.${var.domain_name}"
  zone_id         = module.route53.zone_id
  acm_arn         = module.acm.acm_arn
  vpc_id          = module.network.vpc_id
  security_groups = [module.network.allow_web_sg]
  subnets         = module.network.public_subnets
}

module "ses" {
  source = "./modules/ses"
  name   = var.project
  email  = "manjunath.poilath@psiog.com"
}

module "rds" {
  depends_on          = [module.network]
  source              = "./modules/rds"
  name                = var.project
  vpc_id              = module.network.vpc_id
  zone_id             = module.route53.zone_id
  domain_name         = "db.${var.domain_name}"
  publicly_accessible = var.environment == "dev" ? true : false
  subnets             = var.environment == "dev" ? module.network.public_subnets : module.network.private_subnets
  security_group = [
    module.network.allow_mysql
  ]
  instance_type = var.environment == "dev" ? "db.t2.micro" : var.rds_config["instance_type"]
  storage       = var.rds_config["storage"]
}

module "cache" {
  depends_on    = [module.network]
  source        = "./modules/cache"
  name          = var.project
  domain_name   = "cache.${var.domain_name}"
  zone_id       = module.route53.zone_id
  instance_type = var.environment == "dev" ? "cache.t2.micro" : var.cache_config["instance_type"]
  subnets       = module.network.private_subnets
  security_group = [
    module.network.allow_redis,
  ]
}

module "asg" {
  depends_on       = [module.load_balancer]
  source           = "./modules/asg"
  name             = var.project
  region           = var.region
  environment      = var.environment
  domain_name      = "test.${var.domain_name}"
  zone_id          = module.route53.zone_id
  key_name         = var.ec2_config["key_name"]
  image_id         = var.ec2_config["image_id"]
  instance_type    = var.environment == "dev" ? "t2.micro" : var.ec2_config["instance_type"]
  instance_count   = var.environment == "dev" ? 1 : lookup(local.instance_map, var.users)
  load_balancer_id = var.environment == "dev" ? "" : module.load_balancer[0].target_group_arn
  security_group = [
    module.network.allow_web_sg,
    module.network.allow_mysql
  ]
  subnets = var.environment == "dev" ? module.network.public_subnets : module.network.private_subnets
}


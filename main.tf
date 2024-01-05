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
}

module "network" {
  source          = "./modules/network"
  name            = var.project
  description     = "VPC For Test Drive Powered By Moodle"
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
}

module "cicd" {
  source = "./modules/cicd"
  name   = var.project
  environment_variables = [
    {
      name  = "region",
      value = var.region
      type  = "PLAINTEXT"
    },
    {
      name  = "rds_config",
      value = aws_ssm_parameter.rds_config.name
      type  = "PARAMETER_STORE"
    },
    {
      name  = "ec2_config",
      value = aws_ssm_parameter.ec2_config.name
      type  = "PARAMETER_STORE"
    },
    {
      name  = "ecs_environment",
      value = aws_ssm_parameter.ecs_environment.name
      type  = "PARAMETER_STORE"
    },
    {
      name  = "container_config",
      value = aws_ssm_parameter.container_config.name
      type  = "PARAMETER_STORE"
    }
  ]
  vpc_id  = module.network.vpc_id
  subnets = module.network.private_subnets
  security_groups = [
    module.network.allow_web_sg
  ]
}

module "acm" {
  source      = "./modules/acm"
  domain_name = "cloudbreathe.in"
}

module "route53" {
  depends_on                = [module.acm]
  source                    = "./modules/route53"
  domain_name               = "cloudbreathe.in"
  acm_arn                   = module.acm.acm_arn
  domain_validation_options = module.acm.domain_validation_options
}

module "load_balancer" {
  depends_on      = [module.network, module.acm]
  source          = "./modules/load_balancer"
  name            = var.project
  domain_name     = "cloudbreathe.in"
  zone_id         = module.route53.zone_id
  acm_arn         = module.acm.acm_arn
  vpc_id          = module.network.vpc_id
  security_groups = [module.network.allow_web_sg]
  subnets         = module.network.public_subnets
}

module "ses" {
  source = "./modules/ses"
  name   = var.project
  email  = "manjunathpv@outlook.com"
}

module "rds" {
  depends_on = [module.network]
  source     = "./modules/rds"
  name       = var.project
  vpc_id     = module.network.vpc_id
  subnets    = module.network.private_subnets
  security_group = [
    module.network.allow_mysql
  ]
  instance_type = var.rds_config["instance_type"]
  storage       = var.rds_config["storage"]
}

module "cache" {
  depends_on = [module.network]
  source     = "./modules/cache"
  name       = var.project
  subnets    = module.network.private_subnets
  security_group = [
    module.network.allow_redis,
  ]
}

module "efs" {
  depends_on       = [module.network]
  source           = "./modules/efs"
  name             = var.project
  subnets_to_mount = module.network.private_subnets
  security_group   = [module.network.allow_nfs_sg]
}

module "asg" {
  depends_on    = [module.network]
  source        = "./modules/asg"
  name          = var.project
  image_id      = var.ec2_config["image_id"]
  instance_type = var.ec2_config["instance_type"]
  users         = var.ec2_config["users"]
  security_group = [
    module.network.allow_nfs_sg,
    module.network.allow_web_sg,
    module.network.allow_mysql
  ]
  subnets = module.network.private_subnets
}

module "ecr" {
  depends_on = [module.network]
  source     = "./modules/ecr"
  name       = var.project
  region     = var.region
  environment = merge(var.ecs_environment,
    {
      CONTAINER_NAME = "cloudbreathe.in"
      DB_PASS        = module.rds.db_password
      DB_HOST        = module.rds.db_endpoint
      DB_USER        = module.rds.db_username
      SMTP_HOST      = "email-smtp.${var.region}.amazonaws.com"
      SMTP_PORT      = "25"
      SMTP_PASSWORD  = module.ses.smtp_password
    }
  )
}

module "ecs" {
  depends_on = [module.ses, module.efs, module.rds, module.cache, module.load_balancer, #module.asg, 
  module.ecr]
  source               = "./modules/ecs"
  name                 = var.project
  region               = var.region
  vpc_id               = module.network.vpc_id
  container_config     = var.container_config
  efs_arn              = module.efs.fs_arn
  efs_access_point_arn = module.efs.access_point_arn
  efs_access_point_id  = module.efs.access_point_id
  target_group_arn     = module.load_balancer.target_group_arn
  asg_arn              = module.asg.autoscaling_group_arn
  moodle_image_uri     = module.ecr.moodle_image_uri
  subnets              = module.network.private_subnets
  efs_id               = module.efs.efs_id
  security_group = [
    module.network.allow_nfs_sg,
    module.network.allow_web_sg,
    module.network.allow_mysql
  ]
}

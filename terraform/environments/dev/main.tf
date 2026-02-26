module "alb" {
  source            = "../../modules/alb"
  alb_sg            = module.security.alb_sg
  public_subnet     = module.vpc.public_subnet
  vpc               = module.vpc.vpc
  frontend_instance = module.instance.frontend_instance
}

module "instance" {
  source                  = "../../modules/instance"
  frontend_subnet         = module.vpc.frontend_subnet
  backend_subnet          = module.vpc.backend_subnet
  database_subnet         = module.vpc.database_subnet
  frontend_security_group = module.security.frontend_security_group
  backend_security_group  = module.security.backend_security_group
  database_security_group = module.security.database_security_group
  mongodb_root_password = var.mongodb_root_password
  mongodb_password = var.mongodb_password
  docker_username = var.docker_username
}

module "security" {
  source = "../../modules/security"
  vpc    = module.vpc.vpc
}

module "vpc" {
  source = "../../modules/vpc"
  region = var.region
}
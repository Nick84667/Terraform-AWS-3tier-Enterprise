module "network" {
  source = "./modules/network"

  name_prefix      = local.name_prefix
  vpc_cidr         = var.vpc_cidr
  azs              = local.azs
  nat_gateway_mode = var.nat_gateway_mode

  tags = {
    Project = var.project_name
    Env     = var.environment
  }
}

module "security" {
  source = "./modules/security"

  name_prefix = local.name_prefix
  vpc_id      = module.network.vpc_id
  app_port    = var.app_port
  db_port     = var.db_port

  tags = {
    Project = var.project_name
    Env     = var.environment
  }
}

module "alb_public" {
  source = "./modules/alb-public"

  name_prefix           = local.name_prefix
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security.alb_public_sg_id
  target_port           = 80
  health_check_path     = "/"

  tags = {
    Project = var.project_name
    Env     = var.environment
  }
}

module "network" {
  source = "./modules/network"

  name_prefix      = local.name_prefix
  vpc_cidr         = var.vpc_cidr
  azs              = local.azs
  nat_gateway_mode = var.nat_gateway_mode

  tags = local.network_tags
}

module "security" {
  source = "./modules/security"

  name_prefix = local.name_prefix
  vpc_id      = module.network.vpc_id
  app_port    = var.app_port
  db_port     = var.db_port

  tags = local.security_tags
}

module "alb_public" {
  source = "./modules/alb-public"

  name_prefix           = local.name_prefix
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security.alb_public_sg_id
  target_port           = 80
  health_check_path     = "/"

  tags = local.alb_public_tags
}

module "web_tier" {
  source = "./modules/web-tier"

  name_prefix       = local.name_prefix
  subnet_ids        = module.network.web_subnet_ids
  security_group_id = module.security.web_sg_id
  target_group_arn  = module.alb_public.web_target_group_arn

  instance_type    = var.web_instance_type
  desired_capacity = var.web_desired_capacity
  min_capacity     = var.web_min_capacity
  max_capacity     = var.web_max_capacity

  tags = local.web_tier_tags
}

module "alb_internal" {
  source = "./modules/alb-internal"

  name_prefix           = local.name_prefix
  vpc_id                = module.network.vpc_id
  subnet_ids            = module.network.app_subnet_ids
  alb_security_group_id = module.security.alb_internal_sg_id
  target_port           = var.app_port
  health_check_path     = "/"

  tags = local.alb_internal_tags
}

module "app_tier" {
  source = "./modules/app-tier"

  name_prefix       = local.name_prefix
  subnet_ids        = module.network.app_subnet_ids
  security_group_id = module.security.app_sg_id
  target_group_arn  = module.alb_internal.app_target_group_arn
  app_port          = var.app_port

  instance_type    = var.app_instance_type
  desired_capacity = var.app_desired_capacity
  min_capacity     = var.app_min_capacity
  max_capacity     = var.app_max_capacity

  tags = local.app_tier_tags
}

module "database" {
  source = "./modules/database"

  name_prefix            = local.name_prefix
  subnet_ids             = module.network.db_subnet_ids
  vpc_security_group_ids = [module.security.db_sg_id]

  engine         = var.database_engine
  engine_version = var.database_engine_version
  db_name        = var.database_name

  master_username = var.database_username

  instance_class    = var.database_instance_class
  allocated_storage = var.database_allocated_storage
  storage_type      = var.database_storage_type

  backup_retention_period = var.database_backup_retention_period
  apply_immediately       = true

  deletion_protection = var.database_deletion_protection
  skip_final_snapshot = var.database_skip_final_snapshot

  storage_encrypted   = true
  publicly_accessible = false

  tags = local.database_tags
}

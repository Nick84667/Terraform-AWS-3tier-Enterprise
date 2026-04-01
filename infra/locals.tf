locals {
  # -----------------------------------------------------------------------------
  # Core normalized context
  # -----------------------------------------------------------------------------
  project_name = lower(trimspace(var.project_name))
  environment  = lower(trimspace(var.environment))
  aws_region   = lower(trimspace(var.aws_region))

  # Stable naming prefix used across the root module and child modules.
  name_prefix = "${local.project_name}-${local.environment}"

  # Availability Zones consumed by the network module.
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  # -----------------------------------------------------------------------------
  # Standard component names
  # -----------------------------------------------------------------------------
  components = {
    network       = "network"
    security      = "security"
    alb_public    = "alb-public"
    alb_internal  = "alb-internal"
    web_tier      = "web-tier"
    app_tier      = "app-tier"
    database      = "database"
    observability = "observability"
  }

  resource_names = {
    for key, value in local.components :
    key => "${local.name_prefix}-${value}"
  }

  # Common resource names that can be reused progressively by modules.
  vpc_name                = "${local.name_prefix}-vpc"
  internet_gateway_name   = "${local.name_prefix}-igw"
  nat_gateway_name        = "${local.name_prefix}-nat"
  public_route_table_name = "${local.name_prefix}-public-rt"
  web_route_table_name    = "${local.name_prefix}-web-rt"
  app_route_table_name    = "${local.name_prefix}-app-rt"
  db_route_table_name     = "${local.name_prefix}-db-rt"
  db_subnet_group_name    = "${local.name_prefix}-db-subnet-group"
  public_alb_name         = local.resource_names.alb_public
  internal_alb_name       = local.resource_names.alb_internal
  web_security_group_name = "${local.name_prefix}-web-sg"
  app_security_group_name = "${local.name_prefix}-app-sg"
  db_security_group_name  = "${local.name_prefix}-db-sg"
  alb_public_sg_name      = "${local.name_prefix}-alb-public-sg"
  alb_internal_sg_name    = "${local.name_prefix}-alb-internal-sg"

  # -----------------------------------------------------------------------------
  # Enterprise tag baseline (compatible with current variables.tf)
  # -----------------------------------------------------------------------------
  common_tags = {
    Project     = local.project_name
    Environment = local.environment
    Env         = local.environment
    ManagedBy   = "Terraform"
    Terraform   = "true"
  }

  component_tags = {
    for key, value in local.components :
    key => merge(local.common_tags, {
      Component = value
      Name      = local.resource_names[key]
    })
  }

  # Frequently used aliases to keep main.tf readable.
  network_tags       = local.component_tags.network
  security_tags      = local.component_tags.security
  alb_public_tags    = local.component_tags.alb_public
  alb_internal_tags  = local.component_tags.alb_internal
  web_tier_tags      = local.component_tags.web_tier
  app_tier_tags      = local.component_tags.app_tier
  database_tags      = local.component_tags.database
  observability_tags = local.component_tags.observability

  # -----------------------------------------------------------------------------
  # Subnet tier labels
  # -----------------------------------------------------------------------------
  subnet_tiers = {
    public = "public"
    web    = "web"
    app    = "app"
    db     = "db"
  }

  # -----------------------------------------------------------------------------
  # Environment flags
  # -----------------------------------------------------------------------------
  is_lab  = local.environment == "lab"
  is_dev  = local.environment == "dev"
  is_prod = local.environment == "prod"
}

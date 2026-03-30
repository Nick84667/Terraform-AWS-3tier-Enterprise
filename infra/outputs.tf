output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "web_subnet_ids" {
  value = module.network.web_subnet_ids
}

output "app_subnet_ids" {
  value = module.network.app_subnet_ids
}

output "db_subnet_ids" {
  value = module.network.db_subnet_ids
}

output "nat_gateway_ids" {
  value = module.network.nat_gateway_ids
}

output "alb_public_sg_id" {
  value = module.security.alb_public_sg_id
}

output "web_sg_id" {
  value = module.security.web_sg_id
}

output "alb_internal_sg_id" {
  value = module.security.alb_internal_sg_id
}

output "app_sg_id" {
  value = module.security.app_sg_id
}

output "db_sg_id" {
  value = module.security.db_sg_id
}

output "public_alb_dns_name" {
  value = module.alb_public.alb_dns_name
}

output "public_alb_zone_id" {
  value = module.alb_public.alb_zone_id
}

output "web_target_group_arn" {
  value = module.alb_public.web_target_group_arn
}

output "web_asg_name" {
  value = module.web_tier.asg_name
}

output "web_launch_template_id" {
  value = module.web_tier.launch_template_id
}

output "internal_alb_dns_name" {
  value = module.alb_internal.alb_dns_name
}

output "internal_alb_zone_id" {
  value = module.alb_internal.alb_zone_id
}

output "app_target_group_arn" {
  value = module.alb_internal.app_target_group_arn
}

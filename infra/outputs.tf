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

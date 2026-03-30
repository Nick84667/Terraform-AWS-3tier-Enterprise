output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}

output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "web_subnet_ids" {
  value = [for s in aws_subnet.web : s.id]
}

output "app_subnet_ids" {
  value = [for s in aws_subnet.app : s.id]
}

output "db_subnet_ids" {
  value = [for s in aws_subnet.db : s.id]
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "web_route_table_ids" {
  value = [for rt in aws_route_table.web : rt.id]
}

output "app_route_table_ids" {
  value = [for rt in aws_route_table.app : rt.id]
}

output "db_route_table_ids" {
  value = [for rt in aws_route_table.db : rt.id]
}

output "nat_gateway_ids" {
  value = var.nat_gateway_mode == "one_per_az" ? [for ngw in aws_nat_gateway.per_az : ngw.id] : (
    var.nat_gateway_mode == "single" ? [aws_nat_gateway.single[0].id] : []
  )
}

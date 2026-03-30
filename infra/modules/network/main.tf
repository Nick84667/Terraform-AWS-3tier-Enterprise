locals {
  az_count = length(var.azs)

  # Subnet CIDRs derived from the VPC CIDR
  public_subnet_cidrs = [
    for i in range(local.az_count) : cidrsubnet(var.vpc_cidr, 8, i)
  ]

  web_subnet_cidrs = [
    for i in range(local.az_count) : cidrsubnet(var.vpc_cidr, 8, i + 10)
  ]

  app_subnet_cidrs = [
    for i in range(local.az_count) : cidrsubnet(var.vpc_cidr, 8, i + 20)
  ]

  db_subnet_cidrs = [
    for i in range(local.az_count) : cidrsubnet(var.vpc_cidr, 8, i + 30)
  ]

  create_nat_per_az = var.nat_gateway_mode == "one_per_az"
  create_single_nat = var.nat_gateway_mode == "single"
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-vpc"
  })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-igw"
  })
}

# -------------------------
# Subnets
# -------------------------
resource "aws_subnet" "public" {
  for_each = {
    for idx, az in var.azs : idx => {
      az   = az
      cidr = local.public_subnet_cidrs[idx]
    }
  }

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.value.az
  cidr_block              = each.value.cidr
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-public-${each.key + 1}"
    Tier = "public"
  })
}

resource "aws_subnet" "web" {
  for_each = {
    for idx, az in var.azs : idx => {
      az   = az
      cidr = local.web_subnet_cidrs[idx]
    }
  }

  vpc_id            = aws_vpc.this.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-web-${each.key + 1}"
    Tier = "web"
  })
}

resource "aws_subnet" "app" {
  for_each = {
    for idx, az in var.azs : idx => {
      az   = az
      cidr = local.app_subnet_cidrs[idx]
    }
  }

  vpc_id            = aws_vpc.this.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-app-${each.key + 1}"
    Tier = "app"
  })
}

resource "aws_subnet" "db" {
  for_each = {
    for idx, az in var.azs : idx => {
      az   = az
      cidr = local.db_subnet_cidrs[idx]
    }
  }

  vpc_id            = aws_vpc.this.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-db-${each.key + 1}"
    Tier = "db"
  })
}

# -------------------------
# Public route table
# -------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-public-rt"
  })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# -------------------------
# NAT EIPs / NAT Gateways
# -------------------------
resource "aws_eip" "nat" {
  for_each = local.create_nat_per_az ? aws_subnet.public : {}

  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-nat-eip-${each.key + 1}"
  })
}

resource "aws_nat_gateway" "per_az" {
  for_each = local.create_nat_per_az ? aws_subnet.public : {}

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-nat-${each.key + 1}"
  })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_eip" "single_nat" {
  count  = local.create_single_nat ? 1 : 0
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-nat-eip-1"
  })
}

resource "aws_nat_gateway" "single" {
  count = local.create_single_nat ? 1 : 0

  allocation_id = aws_eip.single_nat[0].id
  subnet_id     = aws_subnet.public["0"].id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-nat-1"
  })

  depends_on = [aws_internet_gateway.this]
}

# -------------------------
# Web route tables
# -------------------------
resource "aws_route_table" "web" {
  for_each = aws_subnet.web

  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-web-rt-${each.key + 1}"
  })
}

resource "aws_route" "web_nat_per_az" {
  for_each = local.create_nat_per_az ? aws_subnet.web : {}

  route_table_id         = aws_route_table.web[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.per_az[each.key].id
}

resource "aws_route" "web_nat_single" {
  for_each = local.create_single_nat ? aws_subnet.web : {}

  route_table_id         = aws_route_table.web[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.single[0].id
}

resource "aws_route_table_association" "web" {
  for_each = aws_subnet.web

  subnet_id      = each.value.id
  route_table_id = aws_route_table.web[each.key].id
}

# -------------------------
# App route tables
# -------------------------
resource "aws_route_table" "app" {
  for_each = aws_subnet.app

  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-app-rt-${each.key + 1}"
  })
}

resource "aws_route" "app_nat_per_az" {
  for_each = local.create_nat_per_az ? aws_subnet.app : {}

  route_table_id         = aws_route_table.app[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.per_az[each.key].id
}

resource "aws_route" "app_nat_single" {
  for_each = local.create_single_nat ? aws_subnet.app : {}

  route_table_id         = aws_route_table.app[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.single[0].id
}

resource "aws_route_table_association" "app" {
  for_each = aws_subnet.app

  subnet_id      = each.value.id
  route_table_id = aws_route_table.app[each.key].id
}

# -------------------------
# DB route tables (isolated)
# -------------------------
resource "aws_route_table" "db" {
  for_each = aws_subnet.db

  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-db-rt-${each.key + 1}"
  })
}

resource "aws_route_table_association" "db" {
  for_each = aws_subnet.db

  subnet_id      = each.value.id
  route_table_id = aws_route_table.db[each.key].id
}

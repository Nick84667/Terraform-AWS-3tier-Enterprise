locals {
  db_identifier  = "${var.name_prefix}-postgres"
  db_subnet_name = "${var.name_prefix}-db-subnet-group"
}

resource "aws_db_subnet_group" "this" {
  name       = local.db_subnet_name
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = local.db_subnet_name
    Tier = "database"
  })
}

resource "aws_db_instance" "this" {
  identifier = local.db_identifier

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type

  db_name  = var.db_name
  username = var.master_username

  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids

  publicly_accessible     = var.publicly_accessible
  backup_retention_period = var.backup_retention_period
  apply_immediately       = var.apply_immediately
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot

  storage_encrypted = var.storage_encrypted
  kms_key_id        = var.kms_key_id

  multi_az = false

  tags = merge(var.tags, {
    Name = local.db_identifier
    Tier = "database"
  })
}

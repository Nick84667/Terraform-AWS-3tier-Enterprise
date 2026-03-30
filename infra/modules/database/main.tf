locals {
  cluster_identifier = "${var.name_prefix}-aurora"
  db_subnet_name     = "${var.name_prefix}-db-subnet-group"
}

resource "aws_db_subnet_group" "this" {
  name       = local.db_subnet_name
  subnet_ids = var.subnet_ids

  tags = merge(var.tags, {
    Name = local.db_subnet_name
  })
}

resource "aws_rds_cluster" "this" {
  cluster_identifier = local.cluster_identifier
  engine             = var.database_engine
  engine_version     = var.engine_version

  availability_zones = length(var.availability_zones) > 0 ? var.availability_zones : null

  database_name    = var.database_name
  master_username  = var.master_username
  master_password  = var.master_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids

  backup_retention_period    = var.backup_retention_period
  preferred_backup_window    = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window

  storage_encrypted       = var.storage_encrypted
  kms_key_id              = var.kms_key_id

  apply_immediately       = var.apply_immediately
  deletion_protection     = var.deletion_protection
  skip_final_snapshot     = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : var.final_snapshot_identifier
  delete_automated_backups = var.delete_automated_backups
  copy_tags_to_snapshot    = var.copy_tags_to_snapshot

  tags = merge(var.tags, {
    Name = local.cluster_identifier
    Tier = "database"
  })
}

# Prima istanza: creata per prima, così diventa il writer iniziale del cluster
resource "aws_rds_cluster_instance" "writer" {
  identifier         = "${var.name_prefix}-writer-1"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_class

  engine         = aws_rds_cluster.this.engine
  engine_version = var.engine_version

  db_subnet_group_name                = aws_db_subnet_group.this.name
  publicly_accessible                 = false
  apply_immediately                   = var.apply_immediately
  monitoring_interval                 = var.monitoring_interval
  performance_insights_enabled        = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null

  promotion_tier = 0

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-writer-1"
    Role = "writer"
  })
}

# Seconda istanza: reader fisso
resource "aws_rds_cluster_instance" "reader" {
  identifier         = "${var.name_prefix}-reader-1"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_class

  engine         = aws_rds_cluster.this.engine
  engine_version = var.engine_version

  db_subnet_group_name                  = aws_db_subnet_group.this.name
  publicly_accessible                   = false
  apply_immediately                     = var.apply_immediately
  monitoring_interval                   = var.monitoring_interval
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null

  promotion_tier = 1

  depends_on = [aws_rds_cluster_instance.writer]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-reader-1"
    Role = "reader"
  })
}

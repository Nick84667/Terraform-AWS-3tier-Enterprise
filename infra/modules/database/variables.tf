variable "name_prefix" {
  description = "Resource naming prefix"
  type        = string
}

variable "subnet_ids" {
  description = "DB subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "Security groups attached to the Aurora cluster"
  type        = list(string)
}

variable "availability_zones" {
  description = "Optional list of AZs for the Aurora cluster"
  type        = list(string)
  default     = []
}

variable "database_engine" {
  description = "Aurora engine: aurora-postgresql or aurora-mysql"
  type        = string
  default     = "aurora-postgresql"

  validation {
    condition     = contains(["aurora-postgresql", "aurora-mysql"], var.database_engine)
    error_message = "database_engine must be aurora-postgresql or aurora-mysql."
  }
}

variable "engine_version" {
  description = "Optional Aurora engine version. Leave null to let AWS choose a compatible default."
  type        = string
  default     = null
}

variable "database_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "master_username" {
  description = "Master username"
  type        = string
}

variable "master_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "Aurora provisioned instance class"
  type        = string
  default     = "db.t4g.medium"
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 1
}

variable "preferred_backup_window" {
  description = "Optional preferred backup window"
  type        = string
  default     = null
}

variable "preferred_maintenance_window" {
  description = "Optional maintenance window"
  type        = string
  default     = null
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "Optional KMS key ARN/ID for storage encryption"
  type        = string
  default     = null
}

variable "apply_immediately" {
  description = "Apply modifications immediately"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Enable deletion protection at cluster level"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on cluster deletion"
  type        = bool
  default     = true
}

variable "final_snapshot_identifier" {
  description = "Optional final snapshot identifier if skip_final_snapshot = false"
  type        = string
  default     = null
}

variable "delete_automated_backups" {
  description = "Remove automated backups after cluster deletion"
  type        = bool
  default     = true
}

variable "copy_tags_to_snapshot" {
  description = "Copy tags to snapshots"
  type        = bool
  default     = false
}

variable "monitoring_interval" {
  description = "Enhanced monitoring interval for instances"
  type        = number
  default     = 0
}

variable "performance_insights_enabled" {
  description = "Enable Performance Insights on DB instances"
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "Performance Insights retention period"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags applied to all DB resources"
  type        = map(string)
  default     = {}
}

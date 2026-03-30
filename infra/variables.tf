variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "database_username" {
  type = string
}

variable "az_count" {
  type    = number
  default = 2
}

variable "nat_gateway_mode" {
  type    = string
  default = "one_per_az"

  validation {
    condition     = contains(["one_per_az", "single", "none"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be one_per_az, single, or none."
  }
}

variable "app_port" {
  type    = number
  default = 8080
}

variable "db_port" {
  type    = number
  default = 5432
}

variable "web_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "web_desired_capacity" {
  type    = number
  default = 2
}

variable "web_min_capacity" {
  type    = number
  default = 2
}

variable "web_max_capacity" {
  type    = number
  default = 2
}

variable "app_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "app_desired_capacity" {
  type    = number
  default = 2
}

variable "app_min_capacity" {
  type    = number
  default = 2
}

variable "app_max_capacity" {
  type    = number
  default = 2
}

variable "database_engine" {
  type    = string
  default = "postgres"
}

variable "database_engine_version" {
  type    = string
  default = null
}

variable "database_name" {
  type    = string
  default = "appdb"
}

variable "database_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "database_allocated_storage" {
  type    = number
  default = 20
}

variable "database_storage_type" {
  type    = string
  default = "gp2"
}

variable "database_backup_retention_period" {
  type    = number
  default = 1
}

variable "database_deletion_protection" {
  type    = bool
  default = false
}

variable "database_skip_final_snapshot" {
  type    = bool
  default = true
}

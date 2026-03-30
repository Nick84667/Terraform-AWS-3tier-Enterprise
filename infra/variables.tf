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

variable "database_password" {
  type      = string
  sensitive = true
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

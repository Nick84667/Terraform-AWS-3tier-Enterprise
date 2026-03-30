variable "name_prefix" {
  description = "Common naming prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "app_port" {
  description = "Application port exposed by the app tier"
  type        = number
  default     = 8080
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

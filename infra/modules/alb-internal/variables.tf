variable "name_prefix" {
  description = "Common naming prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the internal ALB target group"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs where the internal ALB will live"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group attached to the internal ALB"
  type        = string
}

variable "target_port" {
  description = "Target group port for the app tier"
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "Health check path for the app target group"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

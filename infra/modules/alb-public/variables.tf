variable "name_prefix" {
  description = "Common naming prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the ALB target group"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group attached to the public ALB"
  type        = string
}

variable "target_port" {
  description = "Target group port for the web tier"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Health check path for the web target group"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

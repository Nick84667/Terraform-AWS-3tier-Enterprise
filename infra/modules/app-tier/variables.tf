variable "name_prefix" {
  description = "Common naming prefix"
  type        = string
}

variable "subnet_ids" {
  description = "Private app subnet IDs for the ASG"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group attached to the app tier instances"
  type        = string
}

variable "target_group_arn" {
  description = "Internal ALB target group ARN for the app tier"
  type        = string
}

variable "app_port" {
  description = "Application port exposed by the app tier"
  type        = number
  default     = 8080
}

variable "instance_type" {
  description = "EC2 instance type for the app tier"
  type        = string
  default     = "t3.micro"
}

variable "desired_capacity" {
  description = "Desired number of instances in the app tier ASG"
  type        = number
  default     = 2
}

variable "min_capacity" {
  description = "Minimum number of instances in the app tier ASG"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of instances in the app tier ASG"
  type        = number
  default     = 2
}

variable "health_check_grace_period" {
  description = "Grace period for ALB health checks"
  type        = number
  default     = 300
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

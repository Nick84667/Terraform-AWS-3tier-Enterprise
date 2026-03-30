variable "name_prefix" {
  description = "Common naming prefix"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "azs" {
  description = "List of availability zones to use"
  type        = list(string)
}

variable "nat_gateway_mode" {
  description = "NAT Gateway strategy: one_per_az | single | none"
  type        = string
  default     = "one_per_az"

  validation {
    condition     = contains(["one_per_az", "single", "none"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be one_per_az, single, or none."
  }
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

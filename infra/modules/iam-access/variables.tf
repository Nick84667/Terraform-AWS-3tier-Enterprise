variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "admin_principal_arn" {
  description = "IAM principal ARN that will receive EKS cluster admin access"
  type        = string
}

variable "readonly_principal_arn" {
  description = "Optional IAM principal ARN for read-only cluster access"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "az_count" {
  description = "Number of AZs"
  type        = number
}

variable "node_instance_types" {
  description = "EKS managed node group instance types"
  type        = list(string)
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "cluster_endpoint_public_access" {
  description = "Expose EKS API publicly"
  type        = bool
}

variable "cluster_endpoint_private_access" {
  description = "Expose EKS API privately"
  type        = bool
}

variable "admin_principal_arn" {
  description = "IAM role ARN with EKS admin access"
  type        = string
}

variable "readonly_principal_arn" {
  description = "Optional IAM role ARN with read-only EKS access"
  type        = string
  default     = ""
}

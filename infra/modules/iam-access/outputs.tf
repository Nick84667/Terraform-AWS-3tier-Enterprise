output "admin_access_entry_principal_arn" {
  description = "Admin principal ARN configured for EKS access"
  value       = aws_eks_access_entry.admin.principal_arn
}

output "readonly_access_entry_principal_arn" {
  description = "Read-only principal ARN configured for EKS access"
  value       = var.readonly_principal_arn != "" ? aws_eks_access_entry.readonly[0].principal_arn : null
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Terraform = "true"
      Project   = var.project_name
      Env       = var.environment
    }
  }
}

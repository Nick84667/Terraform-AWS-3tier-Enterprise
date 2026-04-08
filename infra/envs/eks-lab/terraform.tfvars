project_name = "three-tier-enterprise"
environment  = "eks-lab"

aws_region         = "eu-central-1"
cluster_name       = "eks-lab-enterprise"
kubernetes_version = "1.33"

vpc_cidr = "10.30.0.0/16"
az_count = 2

node_instance_types = ["t3.micro"]

desired_size = 2
min_size     = 1
max_size     = 3

cluster_endpoint_public_access  = true
cluster_endpoint_private_access = true

#  REQUIRED: replace with your real IAM ROLE ARN
admin_principal_arn = "arn:aws:iam::132334512300:user/nickadmin"

# optional
readonly_principal_arn = ""

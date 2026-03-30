project_name = "three-tier-enterprise"
environment  = "lab"
aws_region   = "eu-central-1"
vpc_cidr     = "10.20.0.0/16"

database_username = "dbadmin"

az_count         = 2
nat_gateway_mode = "one_per_az"

app_port = 8080
db_port  = 5432

web_instance_type    = "t3.micro"
web_desired_capacity = 2
web_min_capacity     = 2
web_max_capacity     = 2

app_instance_type    = "t3.micro"
app_desired_capacity = 2
app_min_capacity     = 2
app_max_capacity     = 2

database_engine                  = "postgres"
database_engine_version          = null
database_name                    = "appdb"
database_instance_class          = "db.t3.micro"
database_allocated_storage       = 20
database_storage_type            = "gp2"
database_backup_retention_period = 1
database_deletion_protection     = false
database_skip_final_snapshot     = true

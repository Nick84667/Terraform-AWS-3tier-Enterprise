variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "tfstate_bucket_name" {
  type = string
}

variable "tf_lock_table_name" {
  type = string
}

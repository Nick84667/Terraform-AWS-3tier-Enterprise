output "cluster_id" {
  value = aws_rds_cluster.this.id
}

output "cluster_arn" {
  value = aws_rds_cluster.this.arn
}

output "writer_endpoint" {
  # cluster endpoint = writer endpoint
  value = aws_rds_cluster.this.endpoint
}

output "reader_endpoint" {
  value = aws_rds_cluster.this.reader_endpoint
}

output "writer_instance_endpoint" {
  value = aws_rds_cluster_instance.writer.endpoint
}

output "reader_instance_endpoint" {
  value = aws_rds_cluster_instance.reader.endpoint
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.this.name
}

output "instance_class" {
  value = var.instance_class
}

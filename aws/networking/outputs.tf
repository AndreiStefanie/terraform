output "vpc_id" {
  value = aws_vpc.tf_vpc.id
}

output "db_subnet_group_names" {
  value = aws_db_subnet_group.tf_rds_sng[*].name
}

output "db_security_group_ids" {
  value = [aws_security_group.tf_sg["db"].id]
}

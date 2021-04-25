output "instances" {
  value     = aws_instance.node[*]
  sensitive = true
}

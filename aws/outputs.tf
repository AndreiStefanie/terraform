output "load_balancer_dns" {
  value = module.loadbalancer.dns_name
}

output "ec2_public_ips" {
  value     = { for i in module.compute.instances : i.tags.Name => "${i.public_ip}:${local.app_port}" }
  sensitive = true
}

output "kubeconfig" {
  value     = [for i in module.compute.instances : "export KUBECONFIG=../k3s-${i.tags.Name}.yaml"]
  sensitive = true
}


output "container-host" {
  value = [for c in module.container : join(":", [c.this_container.ip_address, c.this_container.ports[0].external])]
}

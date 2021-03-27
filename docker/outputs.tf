
output "container-host" {
  value = [for i in docker_container.nodered[*] : join(":", [i.ip_address, i.ports[0].external])]
}

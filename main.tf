terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.11.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "docker_volume" "nodered_volume" {
  name = "nodered"
}

resource "random_string" "random" {
  count   = 1
  length  = 4
  upper   = false
  special = false
}

resource "docker_container" "nodered_container" {
  count = 1
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
  }
  volumes {
    volume_name    = "nodered"
    container_path = "/data"
  }
}

output "container-host" {
  value = [for i in docker_container.nodered_container[*] : join(":", [i.ip_address, i.ports[0].external])]
}

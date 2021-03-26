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

resource "docker_container" "nodered_container" {
  name  = "nodered"
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    external = 1880
  }
  volumes {
    volume_name    = "nodered"
    container_path = "/data"
  }
}

output "container-host" {
  value = join(":", [docker_container.nodered_container.ip_address, docker_container.nodered_container.ports[0].external])
}

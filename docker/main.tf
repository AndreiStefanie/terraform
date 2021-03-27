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

resource "docker_image" "nodered" {
  name = "nodered/node-red:latest"
}

resource "docker_volume" "nodered" {
  name = "nodered"
}

resource "random_string" "random" {
  count = var.container_count

  length  = 4
  upper   = false
  special = false
}

resource "docker_container" "nodered" {
  count = var.container_count

  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered.latest
  ports {
    internal = 1880
  }
  volumes {
    volume_name    = "nodered"
    container_path = "/data"
  }
}

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

module "image" {
  source = "./image"
  image  = var.image[var.env]
}

resource "docker_volume" "nodered" {
  name = "nodered"
}

module "container" {
  count = 2

  source = "./container"

  image          = module.image.this_image
  volume_name    = "nodered"
  container_path = "/data"
}

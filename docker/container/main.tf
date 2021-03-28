resource "random_string" "this" {
  length  = 4
  upper   = false
  special = false
}

resource "docker_container" "nodered" {
  name  = join("-", ["nodered", random_string.this.result])
  image = var.image
  ports {
    internal = 1880
  }
  volumes {
    volume_name    = var.volume_name
    container_path = var.container_path
  }
}

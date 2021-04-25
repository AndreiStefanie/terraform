terraform {
  backend "remote" {
    organization = "clover-tech"

    workspaces {
      name = "k8s"
    }
  }
}

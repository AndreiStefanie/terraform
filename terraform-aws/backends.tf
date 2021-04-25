terraform {
  backend "remote" {
    organization = "clover-tech"

    workspaces {
      name = "learning"
    }
  }
}

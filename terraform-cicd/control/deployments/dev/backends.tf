terraform {
  backend "remote" {
    organization = "clover-tech"

    workspaces {
      name = "terraform-dev"
    }
  }
}

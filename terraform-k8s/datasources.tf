data "terraform_remote_state" "kubeconfig" {
  backend = "remote"

  config = {
    organization = "clover-tech"
    workspaces = {
      name = "learning"
    }
  }
}

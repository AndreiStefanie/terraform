terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.9.2"
    }

    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.25.0"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

provider "tfe" {
  token = var.tfe_token
}

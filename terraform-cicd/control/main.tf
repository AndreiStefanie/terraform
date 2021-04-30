locals {
  aws_creds = {
    AWS_ACCESS_KEY_ID     = var.aws_access_key_id
    AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
  }
  organization = "clover-tech"
}

resource "github_repository" "this" {
  name             = "terraform-dev"
  description      = "Repo for terraform AWS resources"
  auto_init        = true
  license_template = "mit"
  visibility       = "private"
}

resource "github_branch_default" "this" {
  repository = github_repository.this.name
  branch     = "main"
}

resource "github_repository_file" "maintf" {
  repository          = github_repository.this.name
  branch              = "main"
  file                = "main.tf"
  content             = file("deployments/dev/main.tf")
  commit_message      = "Managed by Terraform"
  commit_author       = "Andrei Stefanie"
  commit_email        = "andrei.stefanie@gmail.com"
  overwrite_on_create = true
}

resource "tfe_oauth_client" "github" {
  organization     = local.organization
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_token
  service_provider = "github"
}

resource "tfe_workspace" "this" {
  name         = github_repository.this.name
  organization = local.organization
  vcs_repo {
    identifier     = "${var.github_owner}/${github_repository.this.name}"
    oauth_token_id = tfe_oauth_client.github.oauth_token_id
  }
}

resource "tfe_variable" "aws_creds" {
  for_each = local.aws_creds

  key          = each.key
  value        = each.value
  category     = "env"
  sensitive    = true
  workspace_id = tfe_workspace.this.id
  description  = "AWS Credentials"
}

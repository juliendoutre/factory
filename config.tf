terraform {
  required_version = "~> 1.11.1"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.11.1"
    }
  }
}

provider "github" {
  owner = var.owner
}

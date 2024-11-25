resource "github_repository" "factory" {
  name         = "factory"
  description  = "This is a template repository for a Golang based software factory following Software Development Life Cycle (SDLC) best practices."
  visibility   = "public"
  is_template  = true
  homepage_url = "https://github.com/juliendoutre/factory"

  // Disable unused GitHub features
  has_issues      = false
  has_discussions = false
  has_projects    = false
  has_wiki        = false
  has_downloads   = false

  // Configure security features
  vulnerability_alerts = true

  security_and_analysis {
    // This is always enabled for public repositories.
    // advanced_security {
    //   status = "enabled"
    // }

    secret_scanning {
      status = "enabled"
    }

    secret_scanning_push_protection {
      status = "enabled"
    }
  }

  // Configure Git features
  allow_auto_merge            = true
  allow_update_branch         = true
  delete_branch_on_merge      = true
  web_commit_signoff_required = true
  allow_squash_merge          = true
  allow_merge_commit          = false
  allow_rebase_merge          = false
}

resource "github_repository_dependabot_security_updates" "dependabot" {
  repository = github_repository.factory.id
  enabled    = true
}

resource "github_repository_ruleset" "default" {
  name        = "default"
  repository  = github_repository.factory.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    pull_request {
      dismiss_stale_reviews_on_push     = true
      require_code_owner_review         = true
      require_last_push_approval        = true
      required_approving_review_count   = 1
      required_review_thread_resolution = true
    }

    deletion                = true
    update                  = true
    creation                = true
    non_fast_forward        = true
    required_linear_history = true
    required_signatures     = true
  }

  bypass_actors {
    actor_id    = 1 // Org admin
    actor_type  = "OrganizationAdmin"
    bypass_mode = "pull_request"
  }

  bypass_actors {
    actor_id    = 5 // Repo admin
    actor_type  = "RepositoryRole"
    bypass_mode = "pull_request"
  }
}

import {
  id = "factory"
  to = github_repository.factory
}

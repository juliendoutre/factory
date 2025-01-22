resource "github_repository" "repository" {
  name = var.repository

  visibility  = "public"
  is_template = false

  has_issues      = true
  has_discussions = false
  has_downloads   = false
  has_projects    = false
  has_wiki        = false

  delete_branch_on_merge      = true
  web_commit_signoff_required = true

  vulnerability_alerts = true
  allow_update_branch  = true
  allow_auto_merge     = true

  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }

    secret_scanning_push_protection {
      status = "enabled"
    }
  }

  template {
    owner                = "juliendoutre"
    repository           = "template"
    include_all_branches = false
  }

  lifecycle {
    ignore_changes = [
      description,
      homepage_url,
      template,
    ]
  }
}

resource "github_actions_repository_permissions" "actions_permissions" {
  repository = github_repository.repository.name

  enabled         = true
  allowed_actions = "selected"

  allowed_actions_config {
    github_owned_allowed = true
    verified_allowed     = true
    patterns_allowed = [
      "golangci/golangci-lint-action@*",
      "hadolint/hadolint-action@*",
    ]
  }
}

resource "github_repository_dependabot_security_updates" "dependabot_security_updates" {
  repository = github_repository.repository.name
  enabled    = true
}

resource "github_repository_ruleset" "default" {
  name        = "default"
  repository  = github_repository.repository.name
  target      = "branch"
  enforcement = "active"

  bypass_actors {
    actor_id    = 5
    actor_type  = "RepositoryRole"
    bypass_mode = "always"
  }

  conditions {
    ref_name {
      exclude = []
      include = [
        "~DEFAULT_BRANCH",
      ]
    }
  }

  rules {
    creation                = true
    deletion                = true
    non_fast_forward        = true
    required_linear_history = true
    required_signatures     = true

    pull_request {
      dismiss_stale_reviews_on_push     = true
      require_code_owner_review         = true
      require_last_push_approval        = true
      required_approving_review_count   = 1
      required_review_thread_resolution = true
    }
  }
}


resource "github_repository_ruleset" "releases" {
  name        = "releases"
  repository  = github_repository.repository.name
  target      = "tag"
  enforcement = "active"

  bypass_actors {
    actor_id    = 5
    actor_type  = "RepositoryRole"
    bypass_mode = "always"
  }

  conditions {
    ref_name {
      exclude = []
      include = [
        "~ALL",
      ]
    }
  }

  rules {
    creation                      = true
    deletion                      = true
    non_fast_forward              = true
    required_linear_history       = true
    required_signatures           = true
    update                        = true
    update_allows_fetch_and_merge = false
  }
}

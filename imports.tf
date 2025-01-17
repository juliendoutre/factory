import {
  id = var.repository
  to = github_repository.repository
}

import {
  id = var.repository
  to = github_actions_repository_permissions.actions_permissions
}

import {
  id = var.repository
  to = github_repository_dependabot_security_updates.dependabot_security_updates
}

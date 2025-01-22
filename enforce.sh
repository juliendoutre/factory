#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# The only required variable is the repository name
REPOSITORY="$1"
# Infer the owner from the current logged in GitHub user if not specified explicitely
OWNER="${2:-$(gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /user | jq -r -c '.login')}"

# Define a couple of helper functions
cleanup() {
    rm -rf terraform.tfstate terraform.tfstate.backup
}

import_ruleset() {
    RULESET_ID=$(gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /repos/"$OWNER"/"$REPOSITORY"/rulesets | jq -c '.[] | select(.name=='\""$1"\"') | .id')
    if [[ -n "${RULESET_ID}" ]]; then
        terraform import -var owner="$OWNER" -var repository="$REPOSITORY" github_repository_ruleset."$1" "$REPOSITORY":"$RULESET_ID"
    fi
}

# Use GitHub's CLI as an authentication helper
GITHUB_TOKEN=$(gh auth token)
export GITHUB_TOKEN

# Clean up any previous local state
cleanup

# Defer cleaning up local state once done
trap cleanup EXIT

# Initialize state
terraform init

# Import the repository if it already exists
REPOSITORY_ID=$(gh repo view "$REPOSITORY" --json id || echo '{"id": ""}' | jq -r -c '.id')
if [[ -n "${REPOSITORY_ID}" ]]; then
    terraform import -var owner="$OWNER" -var repository="$REPOSITORY" github_repository.repository "$REPOSITORY"
    terraform import -var owner="$OWNER" -var repository="$REPOSITORY" github_actions_repository_permissions.actions_permissions "$REPOSITORY"
    terraform import -var owner="$OWNER" -var repository="$REPOSITORY" github_repository_dependabot_security_updates.dependabot_security_updates "$REPOSITORY"

    # Import eventually defined rulesets
    import_ruleset "releases"
    import_ruleset "default"
fi

# Enforce settings
terraform apply -var owner="$OWNER" -var repository="$REPOSITORY"

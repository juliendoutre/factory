#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Use GitHub's CLI as an authentication helper
GITHUB_TOKEN=$(gh auth token)
export GITHUB_TOKEN

# Clean up any previous local state
rm -rf terraform.tfstate terraform.tfstate.backup

# Initialize state
terraform init

# Enforce settings
terraform apply -var repository="$1"

# Clean up any local state
rm -rf terraform.tfstate terraform.tfstate.backup

# Factory

This is a template repository for a Golang based **software factory** following Software Development Life Cycle (SDLC) best practices.

## The hook

Tired of spending days working on setting CI/CD pipeline? Having to manage countless compliance frameworks requirements? Reinventing the wheel when it comes to deploy your apps in a safe way? Writing thousands lines of YAML?

This project helps you do the heavy lifting of building, testing and deploying your code.

It's very **opinionated** so it may not be a good fit for all use cases. Especially, it supposes the following:
* code is versioned with Git and hosted on a GitHub repository
* all the code base is written in Golang
* applications are deployed to Kubernetes
* signatures are managed with cosign
* infrastructure is managed with Terraform
* the CI runs in GitHub actions and is managed with dagger.io

## Getting started

1. Create a new repository based on this repository.
2. cd `./apps/github/terraform/`
3. GITHUB_TOKEN=$(gh auth token) terraform plan
3. GITHUB_TOKEN=$(gh auth token) terraform apply

## Terminology

* *registry*: an OCI registry, typically ghcr.io
    * *artifact*: anything stored in a registry
        * *blob*: a blob of data, typically a compiled binary
        * *image*: a container image
* *application*: any program
    * *workload*: an application packaged in a container image and running in k8s
    * *binary*: an application packaged as a binary and distributed directly to end users

## Users journeys

As the factory owner:
* I create a brand new GitHub repository under my organization — or user - based on this template
* I configure my repository with sane defaults through a CLI

As a developer:
* I create a feature branch based on `main`
* I commit changes to the code and push my branch to the repo
* The CI runs tests (linters, formaters, unit tests, integration tests) and reports any eventual issues
* The CI builds applications impacted by the change and pushes them to the registry
* The CI lists all planned infrastructure changes
* When merged to `main`
    * the CI applies infrastructure changes
    * the CI promotes built artifacts to released versions

As an auditor:
* I verify commits signatures
* I verify artifact signatures
* I trace any artifact (blob or container image) back to a commit
* I see all changes between two artifact versions
* I list all dependencies being used by an artifact and their related security findings

## Features

* Dependabot auto updates
* Go linting with golangci-lint

## Layout

- `.github/`: GitHub configuration (dependabot, etc.)
- `internal/`: Internal Go packages
- `apps/`: all applications:
    - any app folder is required to contain a `README.md` file describing what it does.
    - if it contains a `terraform/` folder, the underlying infrastructure will be kept in sync at deploy time. Changes will be computed in the CI.
    - if it contains a `main.go` file, it will be built as a binary.
- `dagger/`: dagger.io Go CI

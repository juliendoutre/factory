# Factory

This is a tool to help me configure new GitHub repositories with secure defaults.

It uses the [GitHub Terraform provider](https://registry.terraform.io/providers/integrations/github/latest/docs).

## Prerequisites

```shell
brew install tfenv gh
```

## Usage

```shell
./enforce.sh <REPO>
```

You may want to edit [imports.tf](./imports.tf) to import existing rulesets, or the repository's general config in [main.tf](./main.tf) to tweak the settings depending on your needs.

## Development

### Format the code

```shell
brew install shellcheck
terraform fmt
shellcheck ./*.sh
```

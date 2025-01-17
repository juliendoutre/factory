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

## Development

### Format the code

```shell
brew install shellcheck
terraform fmt
shellcheck ./*.sh
```

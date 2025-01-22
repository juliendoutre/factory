# Factory

This is a tool to help me configure new GitHub repositories with secure defaults.

It uses the [GitHub Terraform provider](https://registry.terraform.io/providers/integrations/github/latest/docs).

## Prerequisites

```shell
brew install tfenv gh jq
```

## Usage

```shell
./enforce.sh <REPO>
```

If `<REPO>` does not exist yet, it will be created based on the https://github.com/juliendoutre/template template.

You may want to edit the repository's configuration in [main.tf](./main.tf) to tweak the settings depending on your needs.

## Development

### Format the code

```shell
brew install shellcheck
terraform fmt
shellcheck ./enforce.sh
```

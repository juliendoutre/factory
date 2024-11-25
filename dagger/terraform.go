package main

import (
	"context"
	"dagger/factory/internal/dagger"
	"path"
)

func (f *Factory) TerraformBuildEnv(source *dagger.Directory) *dagger.Container {
	return dag.Container().
		From("index.docker.io/hashicorp/terraform:1.9").
		WithDirectory("/factory", source).
		WithWorkdir("/factory")
}

func (f *Factory) TerraformFormat(ctx context.Context, source *dagger.Directory) (string, error) {
	return f.TerraformBuildEnv(source).
		WithExec([]string{"terraform", "fmt", "-recursive", "-check"}).
		Stdout(ctx)
}

func (f *Factory) TerraformPlan(
	ctx context.Context,
	source *dagger.Directory,
	githubToken *dagger.Secret,
	app string,
) (string, error) {
	return f.TerraformBuildEnv(source).
		WithSecretVariable("GITHUB_TOKEN", githubToken).
		WithWorkdir(path.Join("/", "factory", "apps", app, "terraform")).
		WithExec([]string{"terraform", "init"}).
		WithExec([]string{"terraform", "plan"}).
		Stdout(ctx)
}

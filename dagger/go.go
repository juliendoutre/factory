package main

import (
	"context"
	"dagger/factory/internal/dagger"
	"path"
)

type Factory struct{}

func (f *Factory) GoBuildEnv(source *dagger.Directory) *dagger.Container {
	return dag.Container().
		From("index.docker.io/golang:1.23.2-alpine3.19").
		WithDirectory("/factory", source).
		WithWorkdir("/factory").
		WithExec([]string{"go", "mod", "download"})
}

func (f *Factory) GoTest(ctx context.Context, source *dagger.Directory) (string, error) {
	return f.GoBuildEnv(source).
		WithExec([]string{"go", "test", "./..."}).
		Stdout(ctx)
}

func (f *Factory) GolangCiLint(ctx context.Context, source *dagger.Directory) (string, error) {
	return dag.Container().
		From("index.docker.io/golangci/golangci-lint:v1.61.0").
		WithDirectory("/factory", source).
		WithWorkdir("/factory").
		WithExec([]string{"golangci-lint", "run"}).
		Stdout(ctx)
}

func (f *Factory) GoBuild(
	ctx context.Context,
	source *dagger.Directory,
	app string,
	arch string,
	os string,
) *dagger.File {
	return f.GoBuildEnv(source).
		WithEnvVariable("CGO_ENABLED", "0").
		WithEnvVariable("GOARCH", arch).
		WithEnvVariable("GOOS", os).
		WithExec([]string{"go", "build", "-o", "/app", path.Join("/", "factory", "apps", app)}).
		File("/app")
}

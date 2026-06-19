
![Release Version](https://img.shields.io/github/v/release/vegito-app/docker?sort=semver)
![CI](https://github.com/vegito-app/docker/actions/workflows/docker-release.yml/badge.svg?branch=main)

# DockerSphere

Standalone OCI foundation images extracted from `vegito-app/local`.

<img width="1254" height="1254" alt="Image" src="https://github.com/user-attachments/assets/9e39416f-1228-4f48-a55e-95fe6016619e" />

This repository contains reusable Docker and runtime foundations used by the Vegito platform:

- Debian development base images
- GPU and desktop runtime images
- X11 / Wayland / Xpra remote desktop stack
- Rootless Docker-in-Docker images
- Rust and Golang base images

## Goals

- Reduce BuildKit DAG complexity in higher-level repositories
- Stabilize reusable OCI foundations
- Improve cache reuse and CI build performance
- Decouple foundation image releases from application repositories
- Provide a component-oriented image composition model
- Expose reproducible developer and runtime distributions

## DockerSphere Model

DockerSphere is built around a component graph rather than a collection of standalone images.

A directory represents a component.

Examples:

```text
/debian/golang
/debian/golang/ai
/debian/docker/dockerd
/debian/vscode
/debian/obs
```

A component inherits the Dockerfile of its parent unless it provides its own Dockerfile.

This allows features to be accumulated incrementally while keeping Dockerfiles focused on a single concern.

Conceptually:

```text
debian
 └── golang
      └── ai
           └── dockerd
                └── desktop-x
                     └── vscode
```

Target names describe accumulated capabilities.

Example:

```text
vegito-trixie-debian-golang-ai-dockerd-desktop-x
```

represents:

```text
Debian
+ Golang
+ AI tooling
+ Docker daemon
+ Desktop runtime
```

### Bundles

Directories under `debian/bundle` represent distributions rather than individual components.

Examples:

```text
/debian/bundle/project
/debian/bundle/project/obs
```

A bundle assembles multiple reusable components into a developer or runtime environment.

### External OCI Foundations

Images stored under `docker.io/` belong to a separate DAG and are published independently.

Buildx contexts may reference them through:

```hcl
contexts = {
  debian = "docker-image://..."
}
```

This creates a compilation boundary, allowing foundation images to evolve independently without forcing a full graph rebuild.

## CI

The repository uses a standalone GitHub Actions pipeline:

```text
version-changelog
    ↓
build-foundation-images
```

The generated OCI images are intended to be consumed from external repositories using immutable image references instead of `target:` BuildKit dependencies.

## Repository Role

This repository provides:

- OCI foundation/runtime images
- reusable desktop/container runtimes
- base developer environments

This repository does not contain:

- business applications
- mobile application releases
- Stripe/Firebase application environments
- integration test orchestration

Those concerns remain in higher-level repositories such as `vegito-app/local` and application repositories.

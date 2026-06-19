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
+ Docker daemon runtime
+ Desktop X runtime
```

The beginning of the target name usually identifies the Dockerfile family used by default.

The remaining suffix describes the base image or capability chain injected through Buildx contexts.

Target names are intended to be self-descriptive.

Agents should be able to infer the expected capability chain directly from the target name without relying on repository-specific implicit rules.

For example:

vegito-trixie-debian-vscode-golang-ai-dockerd

should be interpreted literally as a composition containing:

- vscode
- golang
- ai
- dockerd

and not as:

- vscode implicitly means desktop-x
- ai implicitly means python
- obs implicitly means desktop-x

Even if the current implementation happens to enforce such relationships.

### Capability Extraction

DockerSphere favors extracting optional capabilities into dedicated components.

For example, Docker client tooling and Docker daemon functionality are modeled separately:

```text
/debian/docker
/debian/docker/dockerd
```

This keeps base images lightweight while allowing higher-level distributions to opt into additional runtime capabilities.

### Bake File Locality

Bake files are organized close to the component or distribution slice they describe.

For example:

```text
/debian/bundle/project/docker/docker-bake.hcl
/debian/bundle/project/docker/trixie.docker-bake.hcl
```

This allows the parent bundle to stay readable while specialized targets remain grouped with their capability.

Target names should use descriptive capability names. In particular, `desktop-x` is preferred over the older shorthand `x` for X11 / desktop runtime targets.

### Bundles

Directories under `debian/bundle` represent distributions rather than individual components.

Examples:

```text
/debian/bundle/project
/debian/bundle/project/obs
```

A bundle assembles multiple reusable components into a developer or runtime environment.

Bundles are allowed to represent curated distributions and may intentionally hide internal implementation details.

For example, an `ai` bundle may internally depend on Python tooling because its Dockerfile is implemented in Python.

However, capability-oriented targets should prefer explicit composition in their names so that the Buildx DAG remains understandable without additional repository knowledge.

A useful rule is:

- capabilities should be explicit;
- distributions may aggregate capabilities.

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

The Makefile provides a curated build interface for common workflows. It does not need to expose every Bake target present in the graph.

Naming distinguishes Docker CLI/client support from Docker daemon runtime support:

- `docker` refers to Docker client or Docker tooling.
- `dockerd` refers to a usable Docker daemon / Docker-in-Docker runtime capability.

In practice, `dockerd` images may include the Docker client as part of the usable runtime. Target names therefore prefer `dockerd` over the noisier `docker-dockerd` form.

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

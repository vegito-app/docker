# DockerSphere Agent Guide

## Purpose

This repository is not a collection of independent Docker images.

It describes a component graph built on top of Docker Buildx Bake.

The repository structure is intentionally descriptive.

Agents must reason about components, capabilities, and distributions before reasoning about OCI images.

---

## Core Concepts

### Component

A directory represents a component.

Examples:

- debian
- golang
- ai
- dockerd
- desktop-x
- vscode
- obs

### Dockerfile Inheritance

A component inherits the Dockerfile of its parent directory unless it provides its own Dockerfile.

Examples:

```text
/debian/golang
    Dockerfile

/debian/golang/ai
    inherits /debian/golang/Dockerfile
```

```text
/debian/golang/ai
    Dockerfile
```

In this case the local Dockerfile becomes the new inheritance root.

### Target Naming

Target names describe accumulated capabilities.

Example:

```text
vegito-trixie-debian-golang-ai-dockerd-desktop-x
```

means:

```text
Debian
+ Golang
+ AI tooling
+ Docker daemon
+ Desktop X runtime
```

Target names are descriptive and intentionally verbose.

---

## Bundles

Directories under:

```text
/debian/bundle
```

represent distributions rather than individual components.

Example:

```text
/debian/bundle/project
```

represents a developer distribution.

Example:

```text
/debian/bundle/project/obs
```

represents the project distribution extended with OBS capabilities.

---

## External Images

Images under:

```text
/docker.io
```

belong to a separate DAG.

They are intentionally synchronized to Docker Hub and consumed through:

```hcl
contexts = {
  debian = "docker-image://..."
}
```

This creates compilation boundaries and prevents rebuilding the entire graph after every foundation change.

---

## Naming and Build Interfaces

### `docker` vs `dockerd`

Use `docker` for the Docker CLI/client capability.

Use `dockerd` for Docker daemon / Docker-in-Docker capability.

Target names should include `dockerd` when the image provides or depends on a Docker daemon runtime.

Avoid mixing `docker` and `dockerd` for the same capability in target names.

### Makefile Scope

The Makefile exposes a practical subset of Buildx Bake targets.

It is not expected to expose every target present in the graph.

When reviewing or editing targets, treat the Bake HCL graph as authoritative and the Makefile as a curated interface.

### Release Target Lists

Release target lists should remain coherent with target names.

When a target is renamed in Bake, update the corresponding Makefile target list in the same change.

Do not keep obsolete target aliases unless they are intentionally maintained for compatibility.

---

## Agent Rules

When modifying this repository:

1. Preserve component inheritance.
2. Preserve target naming consistency.
3. Prefer extending the graph instead of duplicating logic.
4. Avoid introducing special cases.
5. Keep Buildx Bake as the source of truth.
6. Treat Makefiles as convenience interfaces.
7. Prefer reusable components over monolithic images.
8. Verify that new targets remain composable.

---

## Mental Model

Do not think:

```text
Repository -> Images
```

Think:

```text
Repository -> Components -> Capabilities -> Distributions -> OCI Images
```

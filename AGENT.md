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

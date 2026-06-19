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

### Component Boundaries

Components should represent a single capability.

Example:

- `docker` provides Docker client tooling.
- `dockerd` provides Docker daemon / DIND capability.

A component may depend on another component, but should not silently absorb its responsibilities.

When functionality becomes optional, prefer extracting it into a dedicated component instead of growing the parent component.

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

Use `dockerd` for a usable Docker daemon / Docker-in-Docker runtime capability.

In practical images, `dockerd` may inherit from or include the `docker` client component so that the daemon is immediately usable from inside the image.

Do not encode this as `docker-dockerd` in target names unless the distinction is truly necessary for a specific target.

Prefer:

```text
vegito-debian-golang-ai-dockerd
```

Over:

```text
vegito-debian-golang-ai-docker-dockerd
```

Target names should include `dockerd` when the image provides or depends on a Docker daemon runtime.

Avoid using both `docker` and `dockerd` in the same target name for the same Docker runtime capability.

### `x` vs `desktop-x`

Use `desktop-x` for X11 / desktop runtime capability in target names.

Avoid introducing new targets with the shorthand `x`.

Legacy tags may still contain `-x-` when kept for compatibility, but newly added variable names and target names should prefer `DESKTOP_X` / `desktop-x`.


### Bake File Locality

A Bake file should describe the component or distribution located in the same directory.

When a section grows around a sub-capability, prefer moving it into a nested Bake file next to that sub-capability.

Example:

```text
/debian/bundle/project/docker/docker-bake.hcl
/debian/bundle/project/docker/trixie.docker-bake.hcl
```

This keeps the parent bundle readable while preserving the full graph through explicit Bake file inclusion.

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

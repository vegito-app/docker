# DockerSphere Agent Guide

## Purpose

This repository is not a collection of independent Docker images.

It describes a component graph built on top of Docker Buildx Bake.

The repository structure is intentionally descriptive.

Agents must reason about components, capabilities, and distributions before reasoning about OCI images.

---

## Core Concepts

### Component

A component is a logical capability or implementation slice in the Buildx Bake graph.

A directory usually groups files related to a component, capability, or distribution slice, but the directory tree is not the authoritative DAG.

Examples of component or capability names:

- debian
- golang
- ai
- docker
- dockerd
- desktop-x
- vscode
- obs
- project

The authoritative graph is expressed by Bake targets, groups, `inherits`, and `contexts` relationships.

### Component Boundaries

Components should represent a single capability.

Example:

- `docker` provides Docker client tooling.
- `dockerd` provides Docker daemon / DIND capability.

A component may depend on another component, but should not silently absorb its responsibilities.

When functionality becomes optional, prefer extracting it into a dedicated component instead of growing the parent component.

### Dockerfile and Context Inheritance

A target uses the Dockerfile and context declared by its Bake definition.

A directory may provide a Dockerfile for a capability family, but a nested Bake file may still define targets whose logical name is longer than the physical path.

Do not assume that every capability in a target name has a corresponding nested directory.

Example:

```text
vegito-trixie-debian-golang-ai-dockerd-desktop-x
```

may be declared under:

```text
/debian/golang/docker-bake.hcl
```

or under:

```text
/debian/golang/ai/trixie.docker-bake.hcl
```

depending on where the HCL is easiest to maintain.

The real build relationship is determined by:

```hcl
inherits = [...]
contexts = {
  debian = "target:..."
}
```

When reasoning about the graph, parse Bake first. Use the file path only as locality and maintainability context.

### Target Naming

Target names describe logical image composition and accumulated capabilities.

Example:

```text
vegito-trixie-debian-golang-ai-dockerd-desktop-x
```

means:

```text
Debian Trixie
+ Golang
+ AI tooling
+ Docker daemon runtime
+ Desktop X runtime
```

Target names should remain as explicit as reasonably possible.

Agents are expected to reconstruct the capability chain directly from the target name.

Avoid relying on hidden rules such as:

- ai implies python;
- vscode implies desktop-x;
- obs implies desktop-x.

Such relationships may exist in the implementation, but they should not be required to understand the graph.

When a capability is important for understanding runtime behavior, prefer keeping it visible in the target name.

The target name is more authoritative than the file path for understanding what image is being produced.

The physical path only tells where the HCL and Dockerfile implementation have been placed.

### Bake File Locality

A Bake file should describe targets related to the component, capability, or distribution slice located in the same directory.

This is a locality rule, not a strict mirror between target names and paths.

For example:

```text
/debian/bundle/project/docker/docker-bake.hcl
/debian/bundle/project/docker/trixie.docker-bake.hcl
```

This keeps the parent bundle readable while preserving the full graph through explicit Bake file inclusion.

Nested Bake files may be introduced to split large HCL sections even when no new Dockerfile is introduced.

Agents must not infer the complete graph from the directory tree alone. They must parse the included Bake files.

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

Bundles are the primary exception to the explicit-capability rule.

A bundle may expose a concise distribution name while internally aggregating several lower-level capabilities.

Agents should therefore distinguish:

- capability targets, which should remain descriptive and composable;
- distribution targets, which may intentionally hide internal implementation details.

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
5. Keep Buildx Bake targets, groups, `inherits`, and `contexts` as the source of truth.
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
Repository -> Bake files -> Targets -> Context edges -> Capability Graph -> Distributions -> OCI Images
```

When in doubt, infer the graph from target names and Bake contexts first.

Directory layout is a maintainability concern.
Bundles are a distribution concern.
The capability graph is the architectural concern.

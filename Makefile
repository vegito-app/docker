VEGITO_PROJECT_NAME := vegito-docker
GIT_HEAD_VERSION ?= $(shell git describe --tags --abbrev=7 --match "v*" 2>/dev/null)

ifdef VERSION
VEGITO_DOCKER_VERSION := $(VERSION)
endif

VEGITO_DOCKER_VERSION ?= $(GIT_HEAD_VERSION)

ifeq ($(VEGITO_DOCKER_VERSION),)
VEGITO_DOCKER_VERSION := latest
endif

export VERSION ?= $(VEGITO_DOCKER_VERSION)

export VEGITO_DOCKER_REGISTRIES ?= dockerhub

export GOOGLE_CLOUD_DOCKER_REGISTRY ?= $(GOOGLE_CLOUD_REGION)-docker.pkg.dev
export GOOGLE_CLOUD_PROJECT_DOCKER_REGISTRY ?= $(GOOGLE_CLOUD_DOCKER_REGISTRY)/$(GOOGLE_CLOUD_PROJECT_ID)
# Use docker.io as the default registry for local public images, but allow overriding it if needed.
# Remove after gcr is back in shape and can be used as the default registry for local public images.
export VEGITO_DOCKER_PUBLIC_REPOSITORY ?= docker.io/dbndev
export VEGITO_DOCKER_BUILD_ENABLE_LOCAL_CACHE ?= false

export VEGITO_DOCKER_ALPINE_DIR ?= $(VEGITO_DOCKER_DIR)/alpine
export VEGITO_DOCKER_DEBIAN_DIR ?= $(VEGITO_DOCKER_DIR)/debian
export VEGITO_DOCKER_IO_DIR     ?= $(VEGITO_DOCKER_DIR)/docker.io

VEGITO_DOCKER_BUILDX_BAKE ?= \
	docker buildx bake \
	-f $(VEGITO_DOCKER_DIR)/docker-bake.hcl \
	-f $(VEGITO_DOCKER_IO_DIR)/docker-bake.hcl \
	$(VEGITO_DOCKER_IO_HUB_IMAGES:%=-f $(VEGITO_DOCKER_IO_DIR)/%.docker-bake.hcl) \
	-f $(VEGITO_DOCKER_ALPINE_DIR)/docker-bake.hcl \
	-f $(VEGITO_DOCKER_DEBIAN_DIR)/docker-bake.hcl \
	-f $(VEGITO_DOCKER_DEBIAN_DIR)/trixie.docker-bake.hcl \
	-f $(VEGITO_DOCKER_DEBIAN_DIR)/docker/dockerd/docker-bake.hcl \
	-f $(VEGITO_DOCKER_DEBIAN_DIR)/docker/dockerd/trixie.docker-bake.hcl \
	-f $(VEGITO_DOCKER_DEBIAN_DIR)/terraform/docker-bake.hcl \
	-f $(VEGITO_DOCKER_DEBIAN_DIR)/terraform/trixie.docker-bake.hcl \
	$(VEGITO_DOCKER_DEBIAN_BUNDLE_SPECIFICS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/bundle/%/docker-bake.hcl) \
	$(VEGITO_DOCKER_DEBIAN_BUNDLE_SPECIFICS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/bundle/%/trixie.docker-bake.hcl) \
	$(VEGITO_DOCKER_DEBIAN_BUNDLE_PROJECT_SPECIFICS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/bundle/project/%/docker-bake.hcl) \
	$(VEGITO_DOCKER_DEBIAN_BUNDLE_PROJECT_SPECIFICS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/bundle/project/%/trixie.docker-bake.hcl) \
	$(VEGITO_DOCKER_DEBIAN_SPECIFICS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/%/docker-bake.hcl) \
	$(VEGITO_DOCKER_DEBIAN_SPECIFICS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/%/trixie.docker-bake.hcl) \
	$(VEGITO_DOCKER_DEBIAN_GOLANG_SPECIFICS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/golang/%/docker-bake.hcl) \
	$(VEGITO_DOCKER_DEBIAN_GOLANG_SPECIFICS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/golang/%/trixie.docker-bake.hcl) \
	$(VEGITO_DOCKER_DEBIAN_VSCODE_SPECIFICS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/vscode/%/docker-bake.hcl) \
	$(VEGITO_DOCKER_DEBIAN_VSCODE_SPECIFICS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/vscode/%/trixie.docker-bake.hcl)

-include docker.mk

# Local/dev: build all images without pushing them.
# Tags are generated for all configured registries.
images: \
docker-login \
vegito-docker-images-multi-registry-release
.PHONY: images

# Local/dev: build images in smaller groups without pushing them.
# Useful when full parallel builds are too heavy for the workstation.
images-groups-build: \
docker-login \
vegito-docker-images
.PHONY: images-groups-build

# CI: build and push all images in parallel.
# Fastest path; requires runners with enough CPU, RAM and disk I/O.
images-ci: \
docker-login \
vegito-docker-images-multi-registry-release-ci
.PHONY: images-ci

# CI: build and push images in smaller groups.
# Safer on constrained runners; slower than the full parallel path.
images-groups-build-ci: \
docker-login \
vegito-docker-images-ci
.PHONY: images-groups-build-ci

images-pull: \
docker-login \
vegito-docker-images-pull-parallel
.PHONY: images-pull

images-push: \
docker-login \
vegito-docker-images-push
.PHONY: images-push

devcontainer: devcontainer-vscode
.PHONY: devcontainer

devcontainer-codespaces: devcontainer-vscode-codespaces
.PHONY: devcontainer-codespaces

vegito-docker-tags-md-ci: vegito-docker-build-tags-list-ci-md
.PHONY: vegito-docker-tags-md-ci

docker-login: vegito-docker-login
.PHONY: docker-login

docker-buildx-bake-target-keys-graph:
	$(VEGITO_DOCKER_BUILDX_BAKE) --print vegito-trixie-debian-project-obs-vscode-golang-ai-dockerd  
.PHONY: docker-buildx-bake-target-keys-graph

check-buildx-bake-duplicates: vegito-docker-check-buildx-bake-duplicates
.PHONY: check-buildx-bake-duplicates

-include local.mk
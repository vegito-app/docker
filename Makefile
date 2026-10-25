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

# Can be set to lab, gcr, dockerhub
export VEGITO_DOCKER_REGISTRIES ?= lab

export GOOGLE_CLOUD_DOCKER_REGISTRY ?= $(GOOGLE_CLOUD_REGION)-docker.pkg.dev
export GOOGLE_CLOUD_PROJECT_DOCKER_REGISTRY ?= $(GOOGLE_CLOUD_DOCKER_REGISTRY)/$(GOOGLE_CLOUD_PROJECT_ID)

export VEGITO_DOCKER_PUBLIC_REPOSITORY ?= registry-public.vegito.app
export VEGITO_DOCKER_PRIVATE_REPOSITORY ?= registry-private.vegito.app
export VEGITO_DOCKER_CACHE_REPOSITORY ?= registry-cache.vegito.app

DOCKER_IMAGES_BUILD_GROUPS ?= \
  dockerhub \
  vegito-app

VEGITO_DOCKER_BUILDX_BAKE_TARGETS_BUILD_GROUPS = $(DOCKER_IMAGES_BUILD_GROUPS) 

VEGITO_DOCKER_IMAGES_BASE ?= $(VEGITO_PROJECT_NAME)

-include docker.mk

# Local/dev: build all images without pushing them.
# Tags are generated for all configured registries.
images-multi-release-fast: \
docker-login \
vegito-docker-images-multi-registry-release
.PHONY: images-multi-release-fast

# Local/dev: build images in smaller groups without pushing them.
# Useful when full parallel builds are too heavy for the workstation.
images: \
docker-login \
vegito-docker-images
.PHONY: images

# CI: build and push all images in parallel.
# Fastest path; requires vegito-app with enough CPU, RAM and disk I/O.
images-ci-multi-registry-release-fast: \
docker-login \
vegito-docker-images-multi-registry-release-ci
.PHONY: images-ci-multi-registry-release-fast

# CI: build and push images in smaller groups.
# Safer on constrained runners; slower than the full parallel path.
images-ci: \
docker-login \
vegito-docker-images-ci
.PHONY: images-ci

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

docker-tags-md-ci: vegito-docker-build-tags-list-ci-md
.PHONY: docker-tags-md-ci

docker-login: vegito-docker-login
.PHONY: docker-login

docker-buildx-setup: vegito-docker-buildx-setup
.PHONY: docker-buildx-setup


check-buildx-bake-duplicates: vegito-docker-check-buildx-bake-duplicates
.PHONY: check-buildx-bake-duplicates

-include local.mk
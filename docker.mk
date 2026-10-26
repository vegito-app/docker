export VEGITO_DOCKER_DIR ?= $(CURDIR)

export VEGITO_DOCKER_ALPINE_DIR ?= $(VEGITO_DOCKER_DIR)/alpine
export VEGITO_DOCKER_DEBIAN_DIR ?= $(VEGITO_DOCKER_DIR)/debian
export VEGITO_DOCKER_IO_DIR     ?= $(VEGITO_DOCKER_DIR)/docker.io

include $(VEGITO_DOCKER_DIR)/lab.mk
include $(VEGITO_DOCKER_DIR)/docker.io/docker.mk

VEGITO_DOCKER_BUILDX_BAKE ?= \
	docker buildx bake \
	-f $(VEGITO_DOCKER_DIR)/docker-bake.hcl \
	-f $(VEGITO_DOCKER_IO_DIR)/docker-bake.hcl \
	$(VEGITO_DOCKER_IO_HUB_BUILDX_BAKE_TARGETS:%=-f $(VEGITO_DOCKER_IO_DIR)/%.docker-bake.hcl) \
	-f $(VEGITO_DOCKER_ALPINE_DIR)/docker-bake.hcl \
	-f $(VEGITO_DOCKER_DEBIAN_DIR)/docker-bake.hcl \
	-f $(VEGITO_DOCKER_DEBIAN_DIR)/trixie.docker-bake.hcl \
	-f $(VEGITO_DOCKER_DEBIAN_DIR)/docker/dockerd/docker-bake.hcl \
	-f $(VEGITO_DOCKER_DEBIAN_DIR)/docker/dockerd/trixie.docker-bake.hcl \
	-f $(VEGITO_DOCKER_DEBIAN_DIR)/terraform/docker-bake.hcl \
	-f $(VEGITO_DOCKER_DEBIAN_DIR)/terraform/trixie.docker-bake.hcl \
	$(VEGITO_DOCKER_DEBIAN_BUNDLE_BUILDX_BAKE_TARGETS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/bundle/%/docker-bake.hcl) \
	$(VEGITO_DOCKER_DEBIAN_BUNDLE_BUILDX_BAKE_TARGETS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/bundle/%/trixie.docker-bake.hcl) \
	$(VEGITO_DOCKER_DEBIAN_BUNDLE_PROJECT_BUILDX_BAKE_TARGETS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/bundle/project/%/docker-bake.hcl) \
	$(VEGITO_DOCKER_DEBIAN_BUNDLE_PROJECT_BUILDX_BAKE_TARGETS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/bundle/project/%/trixie.docker-bake.hcl) \
	$(VEGITO_DOCKER_DEBIAN_BUILDX_BAKE_BASE_TARGETS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/%/docker-bake.hcl) \
	$(VEGITO_DOCKER_DEBIAN_BUILDX_BAKE_BASE_TARGETS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/%/trixie.docker-bake.hcl) \
	$(VEGITO_DOCKER_DEBIAN_GOLANG_BUILDX_BAKE_TARGETS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/golang/%/docker-bake.hcl) \
	$(VEGITO_DOCKER_DEBIAN_GOLANG_BUILDX_BAKE_TARGETS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/golang/%/trixie.docker-bake.hcl) \
	$(VEGITO_DOCKER_DEBIAN_VSCODE_BUILDX_BAKE_TARGETS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/vscode/%/docker-bake.hcl) \
	$(VEGITO_DOCKER_DEBIAN_VSCODE_BUILDX_BAKE_TARGETS:%=-f $(VEGITO_DOCKER_DEBIAN_DIR)/vscode/%/trixie.docker-bake.hcl)

docker-buildx-bake-target-keys-graph:
	$(VEGITO_DOCKER_BUILDX_BAKE) --print vegito-trixie-debian-project-obs-vscode-golang-ai-dockerd  
.PHONY: docker-buildx-bake-target-keys-graph

vegito-gcr-docker-login: gcloud-auth-docker
	@echo "Logging into $(GOOGLE_CLOUD_PROJECT_DOCKER_REGISTRY)"
	@docker login $(GOOGLE_CLOUD_PROJECT_DOCKER_REGISTRY)
.PHONY: vegito-gcr-docker-login

# Custom values: gcr, dockerhub, ... (space separed)
VEGITO_DOCKER_REGISTRIES ?= lab

vegito-docker-login: $(VEGITO_DOCKER_REGISTRIES:%=vegito-%-docker-login)
	@echo "🔐 Logged into: $(VEGITO_DOCKER_REGISTRIES)"
.PHONY: vegito-docker-login

vegito-docker-sock:
	@echo "🔨  Enabling docker.sock"
	@sudo chmod o+rw /var/run/docker.sock
.PHONY: vegito-docker-sock

vegito-docker-clean: 
	@echo "🧹 Cleaning up Docker..."
	@docker system prune --all --force
.PHONY: vegito-docker-clean

# Groups are used to manage the build process. 
# If an image is built in a group, all images in that group are built together.
VEGITO_DOCKER_BUILDX_BAKE_TARGETS_BUILD_GROUPS ?= \
  dockerhub \
  runners

# Build all images (dev)
# In this variant, images are built and loaded into the local Docker daemon.
# The build does not push images to a remote registry.
vegito-docker-images: $(VEGITO_DOCKER_BUILDX_BAKE_TARGETS_BUILD_GROUPS:%=%-docker-images)
.PHONY: vegito-docker-images

$(VEGITO_DOCKER_BUILDX_BAKE_TARGETS_BUILD_GROUPS:%=%-docker-images): vegito-docker-buildx-setup
	@$(VEGITO_DOCKER_BUILDX_BAKE) --print $(@:%-docker-images=%)
	@$(VEGITO_DOCKER_BUILDX_BAKE) --load $(@:%-docker-images=%)
.PHONY: $(VEGITO_DOCKER_BUILDX_BAKE_TARGETS_BUILD_GROUPS:%=%-docker-images)

vegito-docker-images-multi-registry-release: $(VEGITO_DOCKER_REGISTRIES:%=vegito-docker-images-%-release)
	@echo "✅ DevBuilt local images tagged for all registries successfully. No push performed."
.PHONY: vegito-docker-images-multi-registry-release

vegito-docker-images-gcr-release: vegito-docker-images-release
.PHONY: vegito-docker-images-gcr-release

# Build all images (CI)
# In this variant, images are built and pushed to the remote registry.
vegito-docker-images-ci: $(VEGITO_DOCKER_BUILDX_BAKE_TARGETS_BUILD_GROUPS:%=%-docker-images-ci)
.PHONY: vegito-docker-images-ci

$(VEGITO_DOCKER_BUILDX_BAKE_TARGETS_BUILD_GROUPS:%=%-docker-images-ci): vegito-docker-buildx-setup
	@$(VEGITO_DOCKER_BUILDX_BAKE) --print $(@:%-docker-images-ci=%-ci)
	@$(VEGITO_DOCKER_BUILDX_BAKE) --push $(@:%-docker-images-ci=%-ci)
.PHONY: $(VEGITO_DOCKER_BUILDX_BAKE_TARGETS_BUILD_GROUPS:%=%-docker-images-ci)

vegito-docker-images-multi-registry-release-ci: $(VEGITO_DOCKER_REGISTRIES:%=vegito-docker-images-%-release-ci)
	@echo "✅ CI Built and pushed images to all registries successfully."
.PHONY: vegito-docker-images-multi-registry-release-ci

vegito-docker-images-gcr-release-ci: vegito-docker-images-release-ci
.PHONY: vegito-docker-gcr-images-ci

vegito-docker-group-tags-list-ci: $(VEGITO_DOCKER_BUILDX_BAKE_TARGETS_BUILD_GROUPS:%=%-docker-group-tags-list-ci)
.PHONY: vegito-docker-group-tags-list-ci

$(VEGITO_DOCKER_BUILDX_BAKE_TARGETS_BUILD_GROUPS:%=%-docker-group-tags-list-ci):
	@$(VEGITO_DOCKER_BUILDX_BAKE) --print $(@:%-docker-group-tags-list-ci=%-ci) | jq -r '.target | to_entries[] | .value.tags[]'
.PHONY: $(VEGITO_DOCKER_BUILDX_BAKE_TARGETS_BUILD_GROUPS:%=%-docker-group-tags-list-ci)

vegito-docker-build-tags-list-ci-md:
	@echo "### 🐳 Docker Images Built (excluding latest):"
	@set -e; for group in $(VEGITO_DOCKER_BUILDX_BAKE_TARGETS_BUILD_GROUPS); do \
	  echo "#### Group: '$$group'" ; \
	 $(MAKE) $$group-docker-group-tags-list-ci \
	 | grep -vE 'latest$$' \
	 | grep -v 'make\[1\]\:' \
	 | sed 's/^/- /' || echo "_no tags for group '$$group'_" ; \
	  echo "" ; \
	done
.PHONY: vegito-docker-build-tags-list-ci-md

VEGITO_DOCKER_DEBIAN_DIR ?= $(VEGITO_DOCKER_DIR)/debian

VEGITO_DOCKER_DEBIAN_BUILDX_BAKE_BASE_TARGETS ?= \
 docker \
 flutter \
 golang \
 kubernetes \
 nodejs \
 obs \
 python \
 robotframework \
 rust \
 terraform \
 vscode

VEGITO_DOCKER_DEBIAN_BUNDLE_BUILDX_BAKE_TARGETS ?= \
 ai \
 desktop-x \
 project

VEGITO_DOCKER_DEBIAN_BUNDLE_PROJECT_BUILDX_BAKE_TARGETS ?= \
  docker \
  kubernetes \
  golang \
  obs \
  vscode

VEGITO_DOCKER_DEBIAN_VSCODE_BUILDX_BAKE_TARGETS ?= \
 ai \
 golang

VEGITO_DOCKER_DEBIAN_GOLANG_BUILDX_BAKE_TARGETS ?= \
 ai

VEGITO_DOCKER_DEBIAN_BUILDX_BAKE_TARGETS ?= \
  debian \
  debian-all \
  debian-desktop-x-vscode-golang-ai-dockerd \
  debian-golang-docker \
  debian-golang-dockerd \
  debian-obs-vscode-golang-ai-dockerd \
  debian-project-golang-desktop-x \
  debian-project-golang-docker \
  debian-project-golang-docker-desktop-x \
  debian-project-obs-vscode-golang-ai-dockerd \
  debian-desktop-x-project-obs-vscode-golang-ai-dockerd \
  debian-vscode-golang-ai-dockerd \
  debian-golang-ai-dockerd \
  debian-ai-dockerd \
  debian-python-dockerd \
  debian-dockerd \
  debian-project-vscode-golang-ai-dockerd \
  debian-project-docker-terraform \
  debian-terraform-dockerd \
  $(VEGITO_DOCKER_DEBIAN_BUILDX_BAKE_BASE_TARGETS:%=debian-%) \
  $(VEGITO_DOCKER_DEBIAN_BUILDX_BAKE_BASE_TARGETS:%=debian-%-ai) \
  $(VEGITO_DOCKER_DEBIAN_BUILDX_BAKE_BASE_TARGETS:%=debian-%-desktop-x) \
  $(VEGITO_DOCKER_DEBIAN_BUILDX_BAKE_BASE_TARGETS:%=debian-%-docker-desktop-x) \
  $(VEGITO_DOCKER_DEBIAN_BUILDX_BAKE_BASE_TARGETS:%=debian-%-dockerd-ai) \
  $(VEGITO_DOCKER_DEBIAN_BUILDX_BAKE_BASE_TARGETS:%=debian-%-docker-project) \
  $(VEGITO_DOCKER_DEBIAN_BUILDX_BAKE_BASE_TARGETS:%=debian-%-flutter-desktop-x) \
  $(VEGITO_DOCKER_DEBIAN_BUILDX_BAKE_BASE_TARGETS:%=debian-%-flutter-ai) \
  $(VEGITO_DOCKER_DEBIAN_BUILDX_BAKE_BASE_TARGETS:%=debian-%-flutter-project) \
  $(VEGITO_DOCKER_DEBIAN_BUILDX_BAKE_BASE_TARGETS:%=debian-%-project) \
  $(VEGITO_DOCKER_DEBIAN_BUNDLE_BUILDX_BAKE_TARGETS:%=debian-%) \
  $(VEGITO_DOCKER_DEBIAN_BUNDLE_PROJECT_BUILDX_BAKE_TARGETS:%=debian-project-%) \

VEGITO_DOCKER_TRIXIE_DEBIAN_BUILDX_BAKE_TARGETS ?= \
  $(VEGITO_DOCKER_DEBIAN_BUILDX_BAKE_TARGETS:%=trixie-%)

VEGITO_DOCKER_IO_HUB_BUILDX_BAKE_TARGETS ?= \
  debian \
  golang-alpine \
  golang-debian \
  dind-rootless \
  rust-alpine

VEGITO_DOCKER_BUILDX_BAKE_TARGETS = \
  $(VEGITO_DOCKER_DEBIAN_BUILDX_BAKE_TARGETS) \
  $(VEGITO_DOCKER_TRIXIE_DEBIAN_BUILDX_BAKE_TARGETS) \
  $(VEGITO_DOCKER_IO_HUB_BUILDX_BAKE_TARGETS:%=hub-%)

vegito-docker-hub-images-update:	
	@$(VEGITO_DOCKER_BUILDX_BAKE) --print dockerhub-ci
	@$(VEGITO_DOCKER_BUILDX_BAKE) --push dockerhub-ci
.PHONY: vegito-docker-hub-images-update

$(VEGITO_DOCKER_BUILDX_BAKE_TARGETS:%=vegito-docker-%-images-update-local):
	@$(VEGITO_DOCKER_BUILDX_BAKE) --print $(@:vegito-docker-%-images-update-local=vegito-%)
	@$(VEGITO_DOCKER_BUILDX_BAKE) --load $(@:vegito-docker-%-images-update-local=vegito-%)
.PHONY: $(VEGITO_DOCKER_BUILDX_BAKE_TARGETS:%=vegito-docker-%-images-update-local)

$(VEGITO_DOCKER_BUILDX_BAKE_TARGETS:%=vegito-docker-%-images-update):
	@$(VEGITO_DOCKER_BUILDX_BAKE) --print $(@:vegito-docker-%-images-update=vegito-%-ci)
	@$(VEGITO_DOCKER_BUILDX_BAKE) --push $(@:vegito-docker-%-images-update=vegito-%-ci)
.PHONY: $(VEGITO_DOCKER_BUILDX_BAKE_TARGETS:%=vegito-docker-%-images-update)

vegito-docker-images-release:
	@$(VEGITO_DOCKER_BUILDX_BAKE) --print release
	@$(VEGITO_DOCKER_BUILDX_BAKE) --load release
.PHONY: vegito-docker-images-release

vegito-docker-images-release-ci:
	@$(VEGITO_DOCKER_BUILDX_BAKE) --print release-ci
	@$(VEGITO_DOCKER_BUILDX_BAKE) --push release-ci
.PHONY: vegito-docker-images-release-ci

VEGITO_DOCKER_BUILDX_NAME ?= vegito-project-builder
VEGITO_DOCKER_BUILDX_ARM_BUILDER_NAME ?= mac-arm

VEGITO_DOCKER_BUILDX_ARM_BUILDER_ENDPOINT ?= tcp://arm-builder:2375

# Ajout d'un context docker distant pour le Mac
vegito-docker-context-arm:
	@echo "🔨  Creating buildx context $(VEGITO_DOCKER_BUILDX_ARM_BUILDER_NAME)"
	@docker context inspect $(VEGITO_DOCKER_BUILDX_ARM_BUILDER_NAME) >/dev/null 2>&1 || \
	docker context create $(VEGITO_DOCKER_BUILDX_ARM_BUILDER_NAME) --docker "host=$(VEGITO_DOCKER_BUILDX_ARM_BUILDER_ENDPOINT)"
.PHONY: vegito-docker-context-arm

vegito-docker-context-arm-rm:
	@echo "🔨  Removing buildx context $(VEGITO_DOCKER_BUILDX_ARM_BUILDER_NAME)"
	@docker context rm $(VEGITO_DOCKER_BUILDX_ARM_BUILDER_NAME) || true
.PHONY: vegito-docker-context-arm-rm

vegito-docker-clean-all:
	@$(MAKE) -j \
	  vegito-docker-clean \
	  vegito-docker-buildx-clean \
	  vegito-docker-buildx-cache-clean
.PHONY: vegito-docker-clean-all

VEGITO_DOCKER_BUILDX_ENABLE_ARM_BUILDER ?= false

ifeq ($(VEGITO_DOCKER_BUILDX_ENABLE_ARM_BUILDER),true)
VEGITO_DOCKER_BUILDX_CREATE_DRIVER_OPTS += memory=20g
endif

# Force the local Docker gateway DNS for the native BuildKit daemon.
# This avoids inheriting the LAN DHCP DNS, which cannot resolve Vegito registries.
VEGITO_DOCKER_BUILDX_NATIVE_DNS ?= 172.16.0.1

vegito-docker-buildx-configure-dns:
	@echo "🔧 Configuring native BuildKit DNS: $(VEGITO_DOCKER_BUILDX_NATIVE_DNS)"
	@docker --context default exec \
		buildx_buildkit_$(VEGITO_DOCKER_BUILDX_NAME)0 \
		sh -c 'printf "nameserver %s\n" "$(VEGITO_DOCKER_BUILDX_NATIVE_DNS)" > /etc/resolv.conf'
.PHONY: vegito-docker-buildx-configure-dns

vegito-docker-buildx-setup:
	@echo "🔨  Creating buildx context $(VEGITO_DOCKER_BUILDX_NAME)"
ifeq ($(VEGITO_DOCKER_BUILDX_ENABLE_ARM_BUILDER),true)
	docker buildx inspect $(VEGITO_DOCKER_BUILDX_NAME) >/dev/null 2>&1 || { \
	  docker context use default && \
	  docker buildx create \
	    --name $(VEGITO_DOCKER_BUILDX_NAME) \
		--buildkitd-config buildkitd-arm64.toml \
	    --driver docker-container \
	    --use \
	    --platform linux/amd64 \
	    $(VEGITO_DOCKER_BUILDX_CREATE_DRIVER_OPTS:%=--driver-opt "%"); \
	}
	$(MAKE) vegito-docker-context-arm
	docker buildx inspect $(VEGITO_DOCKER_BUILDX_NAME) | grep $(VEGITO_DOCKER_BUILDX_ARM_BUILDER_NAME) >/dev/null 2>&1 || \
	  docker buildx create \
	    --append \
	    --name $(VEGITO_DOCKER_BUILDX_NAME) \
	    --platform linux/arm64 \
	    $(VEGITO_DOCKER_BUILDX_ARM_BUILDER_NAME)
else
	docker buildx inspect $(VEGITO_DOCKER_BUILDX_NAME) >/dev/null 2>&1 || { \
	  docker context use default && \
	  docker buildx create \
	    --name $(VEGITO_DOCKER_BUILDX_NAME) \
	    --driver docker-container \
		--driver-opt memory=8g \
		--buildkitd-config buildkitd-arm64.toml \
	    --use \
	    --platform linux/arm64 \
	    --platform linux/amd64 \
	    $(VEGITO_DOCKER_BUILDX_CREATE_DRIVER_OPTS:%=--driver-opt "%"); \
	}
endif
	@docker buildx inspect $(VEGITO_DOCKER_BUILDX_NAME) --bootstrap
	@$(MAKE) vegito-docker-buildx-configure-dns
	@docker run --privileged --rm tonistiigi/binfmt --install all
.PHONY: vegito-docker-buildx-setup

vegito-docker-buildx-rm:
	@echo "🔨  Removing buildx context $(VEGITO_DOCKER_BUILDX_NAME)"
	@-docker buildx rm $(VEGITO_DOCKER_BUILDX_NAME)
.PHONY: vegito-docker-buildx-rm

vegito-docker-buildx-clean:
	@echo "🧹 Cleaning up Docker Buildx cache..."
	@docker buildx prune --all --force
.PHONY: vegito-docker-buildx-clean

vegito-docker-buildx-cache-clean: 
	@echo "🧹 Cleaning up Docker Buildx cache..."
	@bash -c '\
	  for i in $$(find . -name "vegito-docker-buildx-cache" -type d) ; do \
	    echo $$i ; \
	    echo Removing $$(du -sh $$i) ; \
		rm -rf $$i ; \
	  done \
	'
.PHONY: vegito-docker-buildx-cache-clean

BUILDX_BAKE_DAG_ITEMS ?= target group variable

vegito-docker-check-buildx-bake-duplicates: $(BUILDX_BAKE_DAG_ITEMS:%=check-buildx-bake-duplicates-%)
.PHONY: check-buildx-bake-duplicates

$(BUILDX_BAKE_DAG_ITEMS:%=check-buildx-bake-duplicates-%):
	grep -R '^$(@:check-buildx-bake-duplicates-%=%) "' . \
	  | sed 's/.*$(@:check-buildx-bake-duplicates-%=%) "//' \
	  | sed 's/".*//' \
	  | sort \
	  | uniq -d
.PHONY: vegito-docker-check-buildx-bake-duplicates-targets
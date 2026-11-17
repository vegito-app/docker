# Targets in this file are helper releasing 
# for github.com/vegito-app/local internal integration.
# In this mode we use the Makefile to produce a sequencial build instead of relaying on
# the Docker Buildx internal DAG. The DAG may be too heavy running on some workstations.
# Useful for local development and testing or if the CI is too slow.
VEGITO_LOCAL_RELEASE_DEFAULT_TARGETS ?= \
  dockerhub-rust-alpine \
  trixie-debian \
  trixie-debian-desktop-x \
  trixie-debian-dockerd \
  trixie-debian-project-docker-terraform \
  trixie-debian-project-golang-docker \
  trixie-debian-robotframework

# This is used in CI to rebuild a subset. 
# To use this feature: define the variable VEGITO_LOCAL_RELEASE_TARGETS.
# cf .github/workflows/docker-fundation-build.yml
# Allow overriding the target list from environment variables.
VEGITO_LOCAL_RELEASE_TARGETS := $(or $(VEGITO_LOCAL_RELEASE_TARGETS), $(VEGITO_LOCAL_RELEASE_DEFAULT_TARGETS))

# Release will trigger a build of target listed in VEGITO_LOCAL_RELEASE_TARGETS, not the complexe images.
# Complexe images may cause a pipeline run to abort due to hardware limitations.
# Use 'make vegito-local-upgrade-images-ci' instead to produce a full build.
vegito-local-release-images-ci: $(VEGITO_LOCAL_RELEASE_TARGETS:%=vegito-docker-%-images-update)
.PHONY: vegito-local-release-images-ci

# Upgrade the base of all images (hub), including the complexe ones
# Building this list in one step may require a large amount of resources. 
VEGITO_LOCAL_UPGRADE_TARGETS = \
  hub \
  $(VEGITO_LOCAL_RELEASE_TARGETS) \
  trixie-debian-desktop-x-project-obs-vscode-golang-ai-docker

# Upgrade will trigger a build of all targets listed in VEGITO_LOCAL_UPGRADE_TARGETS.
vegito-local-upgrade-images-ci:
	@echo "Starting upgrade images CI for github.com/vegito-app/local"
	@$(MAKE) vegito-local-release-images-ci \
	  VEGITO_LOCAL_RELEASE_TARGETS="$(VEGITO_LOCAL_UPGRADE_TARGETS)"
.PHONY: vegito-local-upgrade-images-ci
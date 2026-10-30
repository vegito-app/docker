# Targets in this file are helper releasing 
# for github.com/vegito-app internal integration.

VEGITO_APP_RELEASE_DEFAULT_TARGETS ?= \
  trixie-debian \
  trixie-debian-golang \
  trixie-debian-robotframework \
  trixie-debian-dockerd \
  trixie-debian-desktop-x \
  trixie-debian-flutter-desktop-x \
  trixie-debian-terraform-dockerd \
  trixie-debian-project-docker \
  trixie-debian-project-golang-docker \
  trixie-debian-project-golang-docker-desktop-x

# This is used in CI to rebuild a subset. 
# To use this feature: define the variable VEGITO_APP_RELEASE_TARGETS.
# cf .github/workflows/docker-fundation-build.yml
# Allow overriding the target list from environment variables.
VEGITO_APP_RELEASE_TARGETS := $(or $(VEGITO_APP_RELEASE_TARGETS), $(VEGITO_APP_RELEASE_DEFAULT_TARGETS))

# Release will trigger a build of target listed in VEGITO_APP_RELEASE_TARGETS, not the complexe images.
# Complexe images may cause a pipeline run to abort due to hardware limitations.
# Use 'make vegito-app-upgrade-images-ci' instead to produce a full build.
vegito-app-release-images-ci: $(VEGITO_APP_RELEASE_TARGETS:%=vegito-docker-%-images-update)
.PHONY: vegito-app-release-images-ci

# Upgrade the base of all images (hub), including the complexe ones
# Building this list in one step may require a large amount of resources. 
VEGITO_APP_UPGRADE_TARGETS = \
  hub \
  $(VEGITO_APP_RELEASE_TARGETS) \
  trixie-debian-desktop-x-project-obs-vscode-golang-ai-docker

# Upgrade will trigger a build of all targets listed in VEGITO_APP_UPGRADE_TARGETS.
vegito-app-upgrade-images-ci:
	@echo "Starting upgrade images CI for vegito-app"
	@$(MAKE) vegito-app-release-images-ci \
	  VEGITO_APP_RELEASE_TARGETS="$(VEGITO_APP_UPGRADE_TARGETS)"
.PHONY: vegito-app-upgrade-images-ci
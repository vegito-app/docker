# Targets in this file are helper releasing 
# for github.com/vegito-app internal integration.

VEGITO_APP_INTERNAL_DEFAULT_TARGETS ?= \
  hub \
  trixie-debian \
  trixie-debian-golang \
  trixie-debian-robotframework \
  trixie-debian-dockerd \
  trixie-debian-flutter-desktop-x \
  trixie-debian-project-docker \
  trixie-debian-terraform-dockerd \
  trixie-debian-project-golang-docker \
  trixie-debian-project-golang-docker-desktop-x \
  trixie-debian-desktop-x \
  trixie-debian-desktop-x-project-obs-vscode-golang-ai-dockerd

# This is used in CI to rebuild a subset. 
# To use this feature: define the variable VEGITO_APP_INTERNAL_TARGETS.
# cf .github/workflows/docker-fundation-build.yml
# Allow overriding the target list from environment variables.
VEGITO_APP_INTERNAL_TARGETS := $(or $(VEGITO_APP_INTERNAL_TARGETS), $(VEGITO_APP_INTERNAL_DEFAULT_TARGETS))

vegito-app-release-images-ci: $(VEGITO_APP_INTERNAL_TARGETS:%=vegito-docker-%-images-update)
.PHONY: vegito-app-release-images-ci

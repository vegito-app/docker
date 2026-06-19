# Targets in this file are helper releasing 
# for github.com/vegito-app/local integration.
# It will update the DAG part used by this secondary project.

vegito-local-update: \
vegito-docker-hub-images-update \
vegito-local-debian-images-update \
vegito-local-debian-bookworm-images-update
.PHONY: vegito-local-update

VEGITO_DOCKER_LOCAL_DEBIAN_RELEASE_TARGETS ?= \
  debian-flutter-desktop-x-images-update \
  debian-project-golang-docker-desktop-x-images-update \
  debian-project-golang-docker-images-update \
  debian-project-golang-update \
  debian-project-vscode-golang-ai-dockerd-images-update \
  debian-robotframework-images-update

vegito-local-debian-images-update: $(VEGITO_DOCKER_LOCAL_DEBIAN_RELEASE_TARGETS:%=vegito-docker-trixie-%)
.PHONY: vegito-local-debian-images-update

vegito-local-debian-bookworm-images-update: $(VEGITO_DOCKER_LOCAL_DEBIAN_RELEASE_TARGETS:%=vegito-docker-%)
.PHONY: vegito-local-debian-bookworm-images-update

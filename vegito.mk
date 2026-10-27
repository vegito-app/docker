# Targets in this file are helper releasing 
# for github.com/vegito-app internal integration.
# It will update the DAG part used by this secondary project.

# Use an ordered target list due CI machine limitations.
# We could build a full graph with more powerful build resources.
VEGITO_APP_INTERNAL_TARGETS ?= \
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

vegito-app-release-images-ci: $(VEGITO_APP_INTERNAL_TARGETS:%=vegito-docker-%-images-update)
.PHONY: vegito-app-release-images-ci

# Targets in this file are helper releasing 
# for github.com/vegito-app/local integration.
# It will update the DAG part used by this secondary project.

vegito-local-update: \
vegito-docker-hub-images-update \
vegito-local-debian-images-update \
vegito-local-debian-bookworm-images-update
.PHONY: vegito-local-update

vegito-local-debian-images-update: \
vegito-docker-trixie-debian-flutter-desktop-x-images-update \
vegito-docker-trixie-debian-robotframework-images-update \
vegito-docker-trixie-debian-project-vscode-golang-ai-docker-images-update \
vegito-docker-trixie-debian-project-golang-images-update
.PHONY: vegito-debian-update

vegito-local-debian-bookworm-images-update: \
vegito-docker-debian-flutter-desktop-x-images-update \
vegito-docker-debian-robotframework-images-update \
vegito-docker-debian-project-vscode-golang-ai-docker-images-update \
vegito-docker-debian-project-golang-images-update
.PHONY: vegito-bookworm-debian-update
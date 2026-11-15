group "vegito-dockerhub-debian-ci" {
  targets = [
    "vegito-dockerhub-debian-bookworm-ci",
    "vegito-dockerhub-debian-trixie-ci",
  ]
}

group "vegito-dockerhub-debian" {
  targets = [
    "vegito-dockerhub-debian-bookworm",
    "vegito-dockerhub-debian-trixie",
    "vegito-dockerhub-debian-trixie-golang"
  ]
}

# Bookworm targets
group "vegito-dockerhub-debian-bookworm-ci" {
  targets = [
    "vegito-dockerhub-debian-bookworm-version-ci",
    "vegito-dockerhub-debian-bookworm-latest-ci",
  ]
}

target "vegito-dockerhub-debian-bookworm-base" {
  context    = VEGITO_DOCKER_IO_HUB_DIR
  dockerfile = "debian.Dockerfile"
  args = {
    debian_version = "bookworm"
    go_version     = GO_VERSION
  }
}

variable "VEGITO_DOCKER_HUB_DEBIAN_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_HUB_IMAGE_BASE}/docker-debian:latest"
}

variable "VEGITO_DOCKER_HUB_DEBIAN_IMAGE_VERSION" {
  default = VEGITO_DOCKER_HUB_DEBIAN_IMAGE_LATEST
}

target "vegito-dockerhub-debian-bookworm-latest-ci" {
  inherits = ["vegito-dockerhub-debian-bookworm-base"]
  tags = [
    VEGITO_DOCKER_HUB_DEBIAN_IMAGE_LATEST
  ]
  platforms = platforms
}

target "vegito-dockerhub-debian-bookworm-version-ci" {
  inherits = ["vegito-dockerhub-debian-bookworm-base"]
  tags = [
    VEGITO_DOCKER_HUB_DEBIAN_IMAGE_VERSION
  ]
  platforms = platforms
}

target "vegito-dockerhub-debian-bookworm" {
  inherits = ["vegito-dockerhub-debian-bookworm-base"]
  tags = [
    VEGITO_DOCKER_HUB_DEBIAN_IMAGE_VERSION,
    VEGITO_DOCKER_HUB_DEBIAN_IMAGE_LATEST,
  ]
}

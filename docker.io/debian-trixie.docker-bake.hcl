
# Trixie targets

variable "VEGITO_DOCKER_HUB_TRIXIE_DEBIAN_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_HUB_IMAGE_BASE}/docker-trixie-debian:latest"
}

variable "VEGITO_DOCKER_HUB_TRIXIE_DEBIAN_IMAGE_VERSION" {
  default = VEGITO_DOCKER_HUB_TRIXIE_DEBIAN_IMAGE_LATEST
}

group "vegito-dockerhub-debian-trixie-ci" {
  targets = [
    "vegito-dockerhub-debian-trixie-version-ci",
    "vegito-dockerhub-debian-trixie-latest-ci",
  ]
}

target "vegito-dockerhub-debian-trixie-base" {
  context    = VEGITO_DOCKER_IO_HUB_DIR
  dockerfile = "debian.Dockerfile"
  args = {
    go_version     = GO_VERSION
    debian_version = "trixie"
  }
}

target "vegito-dockerhub-debian-trixie-latest-ci" {
  inherits = ["vegito-dockerhub-debian-trixie-base"]
  tags = [
    VEGITO_DOCKER_HUB_TRIXIE_DEBIAN_IMAGE_LATEST
  ]
  platforms = platforms
}

target "vegito-dockerhub-debian-trixie-version-ci" {
  inherits = ["vegito-dockerhub-debian-trixie-base"]
  tags = [
    VEGITO_DOCKER_HUB_TRIXIE_DEBIAN_IMAGE_VERSION
  ]
  platforms = platforms
}

target "vegito-dockerhub-debian-trixie" {
  inherits = ["vegito-dockerhub-debian-trixie-base"]
  tags = [
    VEGITO_DOCKER_HUB_TRIXIE_DEBIAN_IMAGE_VERSION,
    VEGITO_DOCKER_HUB_TRIXIE_DEBIAN_IMAGE_LATEST,
  ]
}

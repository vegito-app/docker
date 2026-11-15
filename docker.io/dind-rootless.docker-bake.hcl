
variable "VEGITO_DOCKER_HUB_DIND_ROOTLESS_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_HUB_IMAGE_BASE}/docker-dind-rootless:latest"
}

variable "VEGITO_DOCKER_HUB_DIND_ROOTLESS_IMAGE_VERSION" {
  default = VEGITO_DOCKER_HUB_DIND_ROOTLESS_IMAGE_LATEST
}

group "vegito-dockerhub-dind-rootless-ci" {
  targets = [
    "vegito-dockerhub-dind-rootless-version-ci",
    "vegito-dockerhub-dind-rootless-latest-ci",
  ]
}

target "vegito-dockerhub-dind-rootless-base" {
  context    = VEGITO_DOCKER_IO_HUB_DIR
  dockerfile = "dind-rootless.Dockerfile"
}

target "vegito-dockerhub-dind-rootless-version-ci" {
  inherits = ["vegito-dockerhub-dind-rootless-base"]
  tags = [
    VEGITO_DOCKER_HUB_DIND_ROOTLESS_IMAGE_VERSION,
  ]
  platforms = platforms
}

target "vegito-dockerhub-dind-rootless-latest-ci" {
  tags = [
    VEGITO_DOCKER_HUB_DIND_ROOTLESS_IMAGE_LATEST,
  ]
  inherits  = ["vegito-dockerhub-dind-rootless-base"]
  platforms = platforms
}

target "vegito-dockerhub-dind-rootless" {
  tags = [
    VEGITO_DOCKER_HUB_DIND_ROOTLESS_IMAGE_VERSION,
    VEGITO_DOCKER_HUB_DIND_ROOTLESS_IMAGE_LATEST,
  ]
  inherits = ["vegito-dockerhub-dind-rootless-base"]
}

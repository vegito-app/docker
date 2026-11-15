variable "VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_HUB_IMAGE_BASE}/golang-debian:latest"
}

variable "VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION" {
  default = VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_LATEST
}

target "vegito-dockerhub-golang-debian-base" {
  context    = VEGITO_DOCKER_IO_HUB_DIR
  dockerfile = "golang-debian.Dockerfile"
  args = {
    debian_version = "bookworm"
    go_version     = GO_VERSION
  }
}

group "vegito-dockerhub-golang-debian-ci" {
  targets = [
    "vegito-dockerhub-golang-debian-version-ci",
    "vegito-dockerhub-golang-debian-latest-ci",
  ]
}

target "vegito-dockerhub-golang-debian-version-ci" {
  tags = [
    VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION,
  ]
  inherits  = ["vegito-dockerhub-golang-debian-base"]
  platforms = platforms
}

target "vegito-dockerhub-golang-debian-latest-ci" {
  tags = [
    VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_LATEST,
  ]
  inherits  = ["vegito-dockerhub-golang-debian-base"]
  platforms = platforms
}

target "vegito-dockerhub-golang-debian" {
  tags = [
    VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION,
    VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_LATEST,
  ]
  inherits = ["vegito-dockerhub-golang-debian-base"]
}

variable "VEGITO_DOCKER_ALPINE_GOLANG_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_HUB_IMAGE_BASE}/golang-alpine:latest"
}

variable "VEGITO_DOCKER_ALPINE_GOLANG_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_HUB_IMAGE_BASE}/golang-alpine:${VERSION}"
}

target "docker-golang-alpine-base" {
  context    = VEGITO_DOCKER_IO_HUB_DIR
  dockerfile = "golang-alpine.Dockerfile"
}

group "docker-golang-alpine-ci" {
  targets = [
    "docker-golang-alpine-version-ci",
    "docker-golang-alpine-latest-ci",
  ]
}

target "docker-golang-alpine-version-ci" {

  tags = [
    VEGITO_DOCKER_ALPINE_GOLANG_IMAGE_VERSION,
  ]
  inherits  = ["docker-golang-alpine-base"]
  platforms = platforms
}

target "docker-golang-alpine-latest-ci" {
  tags = [
    VEGITO_DOCKER_ALPINE_GOLANG_IMAGE_LATEST,
  ]
  inherits  = ["docker-golang-alpine-base"]
  platforms = platforms
}

target "docker-golang-alpine" {
  tags = [
    VEGITO_DOCKER_ALPINE_GOLANG_IMAGE_VERSION,
    VEGITO_DOCKER_ALPINE_GOLANG_IMAGE_LATEST,
  ]
  inherits = ["docker-golang-alpine-base"]
}

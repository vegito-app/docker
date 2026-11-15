variable "VEGITO_DOCKER_ALPINE_GOLANG_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_HUB_IMAGE_BASE}/golang-alpine:latest"
}

variable "VEGITO_DOCKER_ALPINE_GOLANG_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_HUB_IMAGE_BASE}/golang-alpine:${VERSION}"
}

target "vegito-dockerhub-golang-alpine-base" {
  context    = VEGITO_DOCKER_IO_HUB_DIR
  dockerfile = "golang-alpine.Dockerfile"
}

group "vegito-dockerhub-golang-alpine-ci" {
  targets = [
    "vegito-dockerhub-golang-alpine-version-ci",
    "vegito-dockerhub-golang-alpine-latest-ci",
  ]
}

target "vegito-dockerhub-golang-alpine-version-ci" {

  tags = [
    VEGITO_DOCKER_ALPINE_GOLANG_IMAGE_VERSION,
  ]
  inherits  = ["vegito-dockerhub-golang-alpine-base"]
  platforms = platforms
}

target "vegito-dockerhub-golang-alpine-latest-ci" {
  tags = [
    VEGITO_DOCKER_ALPINE_GOLANG_IMAGE_LATEST,
  ]
  inherits  = ["vegito-dockerhub-golang-alpine-base"]
  platforms = platforms
}

target "vegito-dockerhub-golang-alpine" {
  tags = [
    VEGITO_DOCKER_ALPINE_GOLANG_IMAGE_VERSION,
    VEGITO_DOCKER_ALPINE_GOLANG_IMAGE_LATEST,
  ]
  inherits = ["vegito-dockerhub-golang-alpine-base"]
}

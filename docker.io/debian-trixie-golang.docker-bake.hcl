
variable "VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_HUB_IMAGE_BASE}/golang-debian-trixie:latest"
}

variable "VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION" {
  default = VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_LATEST
}

target "vegito-dockerhub-debian-trixie-golang-base" {
  context    = VEGITO_DOCKER_IO_HUB_DIR
  dockerfile = "golang-debian.Dockerfile"
  args = {
    debian_version = "trixie"
    go_version     = GO_VERSION
  }
}

group "vegito-dockerhub-debian-trixie-golang-ci" {
  targets = [
    "vegito-dockerhub-debian-trixie-golang-version-ci",
    "vegito-dockerhub-debian-trixie-golang-latest-ci",
  ]
}

target "vegito-dockerhub-debian-trixie-golang-version-ci" {

  tags = [
    VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION,
  ]
  inherits  = ["vegito-dockerhub-debian-trixie-golang-base"]
  platforms = platforms
}

target "vegito-dockerhub-debian-trixie-golang-latest-ci" {
  tags = [
    VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_LATEST,
  ]
  inherits  = ["vegito-dockerhub-debian-trixie-golang-base"]
  platforms = platforms
}

target "vegito-dockerhub-debian-trixie-golang" {
  tags = [
    VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION,
    VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_LATEST,
  ]
  inherits = ["vegito-dockerhub-debian-trixie-golang-base"]
}

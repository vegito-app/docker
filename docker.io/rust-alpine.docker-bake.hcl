variable "VEGITO_DOCKER_ALPINE_RUST_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_HUB_IMAGE_BASE}/rust-alpine:latest"
}

variable "VEGITO_DOCKER_ALPINE_RUST_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_HUB_IMAGE_BASE}/rust-alpine:${VERSION}"
}

target "vegito-dockerhub-rust-alpine-base" {
  context    = VEGITO_DOCKER_IO_HUB_DIR
  dockerfile = "rust-alpine.Dockerfile"
}

group "vegito-dockerhub-rust-alpine-ci" {
  targets = [
    "vegito-dockerhub-rust-alpine-version-ci",
    "vegito-dockerhub-rust-alpine-latest-ci",
  ]
}

target "vegito-dockerhub-rust-alpine-version-ci" {

  tags = [
    VEGITO_DOCKER_ALPINE_RUST_IMAGE_VERSION,
  ]
  inherits  = ["vegito-dockerhub-rust-alpine-base"]
  platforms = platforms
}

target "vegito-dockerhub-rust-alpine-latest-ci" {
  tags = [
    VEGITO_DOCKER_ALPINE_RUST_IMAGE_LATEST,
  ]
  inherits  = ["vegito-dockerhub-rust-alpine-base"]
  platforms = platforms
}

target "vegito-dockerhub-rust-alpine" {
  tags = [
    VEGITO_DOCKER_ALPINE_RUST_IMAGE_VERSION,
    VEGITO_DOCKER_ALPINE_RUST_IMAGE_LATEST,
  ]
  inherits = ["vegito-dockerhub-rust-alpine-base"]
}

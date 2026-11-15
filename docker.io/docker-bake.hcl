variable "VEGITO_DOCKER_IO_HUB_DIR" {
  default = "${VEGITO_DOCKER_DIR}/docker.io"
}

variable "VEGITO_DOCKER_HUB_IMAGE_BASE" {
  default = "${VEGITO_DOCKER_PRIVATE_REPOSITORY}/dockerhub"
}

# Groups are used to build incrementally the images in the correct order:
# - Dockerhub: the base images that we replicate to our private repository
# - Runners: the most basic level, they are used to run the services and applications
# - Builders: used to build the services, applications and the local development environments
# - Services: the dependencies of the applications, they are used to run the applications
# - Applications: the end products that we want to run and test
group "dockerhub" {
  targets = [
    "vegito-dockerhub-debian",
    "vegito-dockerhub-golang-debian",
    "vegito-dockerhub-debian-trixie",
    "vegito-dockerhub-debian-trixie-golang",
    "vegito-dockerhub-dind-rootless",
    "vegito-dockerhub-golang-alpine",
    "vegito-dockerhub-rust-alpine",
  ]
}

group "dockerhub-ci" {
  targets = [
    "vegito-dockerhub-debian-ci",
    "vegito-dockerhub-golang-debian-ci",
    "vegito-dockerhub-debian-trixie-ci",
    "vegito-dockerhub-debian-trixie-golang-ci",
    "vegito-dockerhub-dind-rootless-ci",
    "vegito-dockerhub-golang-alpine-ci",
    "vegito-dockerhub-rust-alpine-ci",
  ]
}

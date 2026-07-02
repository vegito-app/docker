variable "VEGITO_DOCKER_DEBIAN_TERRAFORM_DIR" {
  default = "${VEGITO_DOCKER_DEBIAN_DIR}/terraform"
}

target "vegito-debian-terraform-base" {
  context = VEGITO_DOCKER_DEBIAN_TERRAFORM_DIR
  args = {
    terraform_version = TERRAFORM_VERSION
    debian_version = "bookworm"
  }
}

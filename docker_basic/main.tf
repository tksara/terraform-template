terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.10.0"
    }
  }
}

# Configure the Docker provider
provider "docker" {
  host = "${var.host}"
}

# Create a container
resource "docker_container" "host1" {
  image = "${docker_image.ubuntu.latest}"
  name = "host1"
  attach = false
  must_run = true
  command = ["sleep", "600"]
}

resource "docker_container" "host2" {
  image = "${docker_image.alpine.latest}"
  name = "host2"
  attach = false
  must_run = true
  command = ["sleep", "600"]
}

resource "docker_image" "ubuntu" {
  name = "ubuntu:latest"
}

data "docker_registry_image" "ubuntu" {
  name = "ubuntu:18.04"
}

resource "docker_image" "alpine" {
  name = "alpine:latest"
}

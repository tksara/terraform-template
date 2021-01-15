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
  host = "http://10.97.101.54:2375"
}

# Create a container
resource "docker_container" "foo" {
  image = "${docker_image.ubuntu.latest}"
  name  = "foo"
}

resource "docker_image" "ubuntu" {
  name = "ubuntu:latest"
}
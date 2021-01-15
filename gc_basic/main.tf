variable "project" {default = "cda-infrastructuremanager"}
variable "region" {default = "europe-west3"}
variable "image" {default = "debian-cloud/debian-10"}
variable "gc_credentials" {}
variable "infrastructure_name" {default = "demo-infrastructure"}
variable "zone" {default = "europe-west3-a"}

variable "num_nodes" {
  description = "Number of nodes to create"
  default     = 1
}

locals {
	id = "${random_integer.name_extension.result}"
}

resource "random_integer" "name_extension" {
  min     = 1
  max     = 99999
}

provider "google" {
  credentials = "${var.gc_credentials}"
  project     = "${var.project}"
  region      = "${var.region}"
}

resource "google_compute_instance" "default" {
  count        = "${var.num_nodes}"
  project      = "${var.project}"
  zone         = "${var.zone}"
  name         = "${var.infrastructure_name}-${count.index + 1}-${local.id}"
  machine_type = "e2-micro"
  
  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }
  
  network_interface {
    network = "default"
    access_config {
    }
  }
}

output "name_output" {
	description = "Instance name"
	value       = "${google_compute_instance.default.*.name[0]}"
}

output "project_output" {
	description = "Project name"
	value       = "${google_compute_instance.default.*.project[0]}"
}

output "internal_ip_output" {
	description = "Internal IP"
	value       = "${google_compute_instance.default.*.network_interface.0.network_ip}"
}

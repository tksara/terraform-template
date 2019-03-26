variable "project" {default = "esd-general-dev"}

variable "credentials" {}

variable "num_nodes" {
  description = "Number of nodes to create"
  default     = 1
}

variable "local_scripts_location" {
	default = "./scripts/local"
}

locals {
	id = "${random_integer.name_extension.result}"
}

resource "random_integer" "name_extension" {
  min     = 1
  max     = 99999
}

provider "google" {
  credentials = "${var.credentials}"
  project     = "${var.project}"
  region      = "us-west1"
}

resource "google_compute_instance" "default" {
  count        = "${var.num_nodes}"
  project      = "${var.project}"
  zone         = "us-west1-b"
  name         = "jeny-em-test-${count.index + 1}-${local.id}"
  machine_type = "f1-micro"
  
  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20190212"
    }
  }
  
  network_interface {
    subnetwork = "test-network-sub"
    subnetwork_project ="esd-general-dev"
  }	
}

 provisioner "local-exec" {
    working_dir = "${var.local_scripts_location}"
    command = "./send_callback_to_servicenow.sh \"${google_compute_instance.default.*.name[0]}\" \"${google_compute_instance.default.*.project[0]}\""
  }

output "name" {
	description = "Instance name"
	value       = "${google_compute_instance.default.*.name[0]}"
}

output "project" {
	description = "Project"
	value       = "${google_compute_instance.default.*.project[0]}"
}


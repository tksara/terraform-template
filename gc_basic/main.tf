variable "project" {default = "my_project_id"}

variable "credentials" {}

variable "num_nodes" {
  description = "Number of nodes to create"
  default     = 1
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
  name         = "jeny-em-test"
  machine_type = "f1-micro"
  
  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20190212"
    }
  }
  
  network_interface {
    subnetwork = "brcm-prod-shared"
   subnetwork_project ="shared-services-080817"
  }
}

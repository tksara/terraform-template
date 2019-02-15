variable "project" {default = "my_project_id"}

variable "credentials" {}

variable "num_nodes" {
  description = "Number of nodes to create"
  default     = 1
}

variable "access_config" {
  description = "The access config block for the instances. Set to [{}] for ephemeral external IP."
  type        = "list"
  default     = []
}

variable "network_ip" {
  description = "Set the network IP of the instance. Useful only when num_nodes is equal to 1."
  default     = ""
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
    subnetwork    = "${google_compute_subnetwork.default.name}"
    access_config = ["${var.access_config}"]
    address       = "${var.network_ip}"
  }
}


output "instance_id" {
  value = "${google_compute_instance.default.self_link}"
}

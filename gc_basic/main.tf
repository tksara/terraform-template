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

variable "network_cidr" {
  default = "10.127.0.0/20"
}

provider "google" {
  credentials = "${var.credentials}"
  project     = "${var.project}"
  region      = "us-west1"
}

resource "google_compute_instance" "jeny-em-test" {
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
     network = "tf-custom-machine"
     access_config {}
  } 
  
  }

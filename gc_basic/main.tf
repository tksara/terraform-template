variable "project" {default = "my_project_id"}
variable "credentials" {}

provider "google" {
  credentials = "${var.credentials}"
  project     = "${var.project}"
  region      = "us-west1"
}



resource "google_compute_instance" "default" {
  project = "${var.project}"
  zone = "us-west1-b"
  name = "tf-compute-1"
  machine_type = "Jeny-EM Test Instance"
  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20190212"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
}

output "instance_id" {
  value = "${google_compute_instance.default.self_link}"
}

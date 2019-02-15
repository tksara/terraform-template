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
  name = "jeny-em-test"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20190212"
    }
  }
  network_interface {
    network = "esd-general-dev-us-west1"
    access_config {
    }
  }
}

output "instance_id" {
  value = "${google_compute_instance.default.self_link}"
}

variable "vsphere_user" {default =""}
variable "vsphere_password" {default =""}
variable "vsphere_server" {default = "vvievc01.sbb01.spoc.global"}

locals {
	id = "${random_integer.name_extension.result}"
}

resource "random_integer" "name_extension" {
  min     = 1
  max     = 99999
}

provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"
  
  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "Test"
}

data "vsphere_datastore" "datastore" {
  name          = "extvimDatastorcluster/local Storage svievmw04"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "Testcluster"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "Client_35"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "ubuntu-minimal-template"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-test-${local.id}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder           = "em"

  num_cpus = 2
  memory   = 8192
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "disk0"
    size  = 50
    thin_provisioned = true
  }
  
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
  }
	
  provisioner "remote-exec" {
	inline = [
		"mkdir -p ${var.remote_working_dir}",
		"mkdir -p ${var.remote_working_dir}/scripts"
	]

	connection {
		type        = "ssh"
		user        = "automic"
		private_key = "${file("${var.private_key_file}")}"
		password    = "${var.ubuntu_password}"
	}
  }

  provisioner "file" {
	source      = "artifacts"
	destination = "${var.remote_working_dir}"

	connection {
		type        = "ssh"
		user        = "automic"
		password    = "${var.ubuntu_password}"
	}
  }

  provisioner "file" {
	source      = "scripts/remote/agent_sm_installation.sh"
	destination = "${var.remote_working_dir}/scripts/agent_sm_installation.sh"

	connection {
		type        = "ssh"
		user        = "automic"
		password    = "${var.ubuntu_password}"
	}
  }

  provisioner "remote-exec" {
	inline = [
		"chmod +x ${var.remote_working_dir}/scripts/agent_sm_installation.sh",
		"${var.remote_working_dir}/scripts/agent_sm_installation.sh ${var.agent_name_prefix}${random_string.cda_entity_name.result} ${var.ae_host} ${var.ae_port} ${var.sm_port} ${var.agent_pass} \"${var.remote_working_dir}\""
	]

	connection {
		type        = "ssh"
		user        = "automic"
		password    = "${var.ubuntu_password}"
	}
  }
}

resource "random_string" "cda_entity_name" {
	length  = 10
	special = false
	lower   = false
}

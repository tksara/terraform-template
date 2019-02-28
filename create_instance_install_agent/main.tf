variable "vsphere_user" {default =""}
variable "vsphere_password" {default =""}
variable "vsphere_server" {default = "vvievc01.sbb01.spoc.global"}

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
  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "ubuntu-minimal-template"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "aws_instance" "cda_instance" {
	ami                    = "${var.aws_ami}"
	instance_type          = "t2.micro"
	vpc_security_group_ids = ["${var.aws_security_group_id}"]
//	vpc_security_group_ids = "vpc-cab585a2"
	key_name	       = "${var.aws_key_name}"

	tags {
		Name = "cda_instance"
	}

	provisioner "remote-exec" {
		inline = [
			"mkdir -p ${var.remote_working_dir}",
			"mkdir -p ${var.remote_working_dir}/scripts"
		]

		connection {
			type        = "ssh"
			user        = "ubuntu"
			private_key = "${file("${var.private_key_file}")}"
		}
	}

	provisioner "file" {
		source      = "artifacts"
		destination = "${var.remote_working_dir}"

		connection {
			type        = "ssh"
			user        = "ubuntu"
			private_key = "${file("${var.private_key_file}")}"
		}
	}

	provisioner "file" {
		source      = "scripts/remote/agent_sm_installation.sh"
		destination = "${var.remote_working_dir}/scripts/agent_sm_installation.sh"

		connection {
			type        = "ssh"
			user        = "ubuntu"
			private_key = "${file("${var.private_key_file}")}"
		}
	}

	provisioner "remote-exec" {
		inline = [
			"chmod +x ${var.remote_working_dir}/scripts/agent_sm_installation.sh",
			"${var.remote_working_dir}/scripts/agent_sm_installation.sh ${var.agent_name_prefix}${random_string.cda_entity_name.result} ${var.ae_host} ${var.ae_port} ${var.sm_port} ${var.agent_pass} \"${var.remote_working_dir}\""
		]

		connection {
			type        = "ssh"
			user        = "ubuntu"
			private_key = "${file("${var.private_key_file}")}"
		}
	}
}



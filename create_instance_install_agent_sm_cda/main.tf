variable "vsphere_user" {default =""}
variable "vsphere_password" {default =""}
variable "vsphere_server" {default = "vvievc01.sbb01.spoc.global"}
variable "infrastructure_name" {default = "jeny-test"}

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
  name             = "${var.infrastructure_name}-${local.id}"
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
		private_key = "${file("${var.private_key_file}")}"
		password    = "${var.ubuntu_password}"
	}
  }

  provisioner "file" {
	source      = "scripts/remote/agent_sm_installation.sh"
	destination = "${var.remote_working_dir}/scripts/agent_sm_installation.sh"

	connection {
		type        = "ssh"
		user        = "automic"
		private_key = "${file("${var.private_key_file}")}"
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
		private_key = "${file("${var.private_key_file}")}"
		password    = "${var.ubuntu_password}"
	}
  }

  provisioner "file" {
	source      = "scripts/local/create_cda_dpltarget.sh"
	destination = "${var.remote_working_dir}/scripts/create_cda_dpltarget.sh"

	connection {
		type        = "ssh"
		user        = "automic"
		private_key = "${file("${var.private_key_file}")}"
		password    = "${var.ubuntu_password}"
	}
  }

  provisioner "remote-exec" {
	inline = [
		"sudo apt-get -y install curl",
		"chmod +x ${var.remote_working_dir}/scripts/create_cda_dpltarget.sh",
		"${var.remote_working_dir}/scripts/create_cda_dpltarget.sh \"${var.cda_host}\" \"${var.cda_user}\" \"${var.cda_pass}\" \"${var.agent_name_prefix}${random_string.cda_entity_name.result}\" \"${var.depltarget_prefix}${random_string.cda_entity_name.result}\" \"${vsphere_virtual_machine.vm.default_ip_address}\" \"${var.tomcat_home_dir}\" \"${var.tomcat_user}\" \"${var.tomcat_pass}\" \"${var.cda_folder}\"" 
	]

	connection {
		type        = "ssh"
		user        = "automic"
		private_key = "${file("${var.private_key_file}")}"
		password    = "${var.ubuntu_password}"
	}
  }
 
 provisioner "file" {
	source      = "scripts/local/create_cda_environment.sh"
	destination = "${var.remote_working_dir}/scripts/create_cda_environment.sh"

	connection {
		type        = "ssh"
		user        = "automic"
		private_key = "${file("${var.private_key_file}")}"
		password    = "${var.ubuntu_password}"
	}
  }

  provisioner "remote-exec" {
	inline = [
		"chmod +x ${var.remote_working_dir}/scripts/create_cda_environment.sh",
		"${var.remote_working_dir}/scripts/create_cda_environment.sh \"${var.cda_host}\" \"${var.cda_user}\" \"${var.cda_pass}\" \"${var.depltarget_prefix}${random_string.cda_entity_name.result}\" \"${var.cda_folder}\" \"${var.environment_prefix}${random_string.cda_entity_name.result}\""
	]

	connection {
		type        = "ssh"
		user        = "automic"
		private_key = "${file("${var.private_key_file}")}"
		password    = "${var.ubuntu_password}"
	}
  }
/*
	provisioner "file" {
		source      = "scripts/remote/tomcat_installation.sh"
		destination = "${var.remote_working_dir}/scripts/tomcat_installation.sh"

		connection {
			type        = "ssh"
			user        = "ubuntu"
			private_key = "${file("${var.private_key_file}")}"
		}
	}
*/
/*
	provisioner "remote-exec" {
		inline = [
			"chmod +x ${var.remote_working_dir}/scripts/tomcat_installation.sh",
			"${var.remote_working_dir}/scripts/tomcat_installation.sh ${var.tomcat_user} ${var.tomcat_pass}"
		]

		connection {
			type        = "ssh"
			user        = "ubuntu"
			private_key = "${file("${var.private_key_file}")}"
		}
	}
*/
/*
	provisioner "local-exec" {
		working_dir = "${var.local_scripts_location}"
		command = "chmod +x *.sh"
	}

	provisioner "local-exec" {
		working_dir = "${var.local_scripts_location}"
		command = "./create_cda_dpltarget.sh \"${var.cda_host}\" \"${var.cda_user}\" \"${var.cda_pass}\" \"${var.agent_name_prefix}${random_string.cda_entity_name.result}\" \"${var.depltarget_prefix}${random_string.cda_entity_name.result}\" \"${vsphere_virtual_machine.vm.default_ip_address}\" \"${var.tomcat_home_dir}\" \"${var.tomcat_user}\" \"${var.tomcat_pass}\" \"${var.cda_folder}\""
	}

	provisioner "local-exec" {
		working_dir = "${var.local_scripts_location}"
		command = "./create_cda_environment.sh \"${var.cda_host}\" \"${var.cda_user}\" \"${var.cda_pass}\" \"${var.depltarget_prefix}${random_string.cda_entity_name.result}\" \"${var.cda_folder}\" \"${var.environment_prefix}${random_string.cda_entity_name.result}\""
	}
*/
/*
	provisioner "local-exec" {
		working_dir = "${var.local_scripts_location}"
		command = "./create_cda_login_object.sh \"${var.cda_host}\" \"${var.cda_user}\" \"${var.cda_pass}\" \"${var.cda_folder}\" \"${var.agent_user}\" \"${var.agent_pass}\" \"${var.agent_name_prefix}${random_string.cda_entity_name.result}\" \"${var.login_object_prefix}${random_string.cda_entity_name.result}\""
	}
*/
/*
	provisioner "local-exec" {
		working_dir = "${var.local_scripts_location}"
		command = "./create_cda_profile.sh \"${var.cda_host}\" \"${var.cda_user}\" \"${var.cda_pass}\" \"${var.profile_prefix}${random_string.cda_entity_name.result}\" \"${var.cda_folder}\" \"${var.login_object_prefix}${random_string.cda_entity_name.result}\" \"${var.application}\" \"${var.environment_prefix}${random_string.cda_entity_name.result}\""
	}
*/
/*
	provisioner "local-exec" {
		working_dir = "${var.local_scripts_location}"
		command = "./create_cda_execution.sh \"${var.cda_host}\" \"${var.cda_user}\" \"${var.cda_pass}\" \"${var.application}\" \"${var.workflow}\" \"${var.package}\" \"${var.profile_prefix}${random_string.cda_entity_name.result}\""
	}
*/
}

resource "random_string" "cda_entity_name" {
	length  = 10
	special = false
	lower   = false
}

output "instance_name" {
  value       = "${vsphere_virtual_machine.vm.*.name[0]}"
}

output "public_ip" {
	value = "${vsphere_virtual_machine.vm.default_ip_address}"
}

output "agent_name" {
	value = "${var.agent_name_prefix}${random_string.cda_entity_name.result}"
}

output "deployment_target" {
	value = "${var.depltarget_prefix}${random_string.cda_entity_name.result}"
}

output "environment" {
	value = "${var.environment_prefix}${random_string.cda_entity_name.result}"
}

/*
output "login_object" {
	value = "${var.login_object_prefix}${random_string.cda_entity_name.result}"
}
*/
/*
output "profile" {
	value = "${var.profile_prefix}${random_string.cda_entity_name.result}"
}
*/

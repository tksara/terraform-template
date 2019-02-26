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

data "vsphere_resource_pool" "pool" {
  name          = "normalPerf"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "nguta04_sample" {
  name             = "nguta04_machine"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 2
  memory   = 1024
  guest_id = "other3xLinux64Guest"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "disk0"
    size  = 20
  }
	
  provisioner "remote-exec" {
		inline = [
			"mkdir -p /home/ubuntu/AE"
		]
		
		connection {
			type        = "ssh"
			user        = "ubuntu"
			private_key = "${file("./nguta04.pem")}"
		}
	}
	
	provisioner "file" {
		source      = "./artifacts"
		destination = "/home/ubuntu/AE"
		
		connection {
			type        = "ssh"
			user        = "ubuntu"
			private_key = "${file("./nguta04.pem")}"
		}
	}
	
	provisioner "file" {
		source      = "./install_agent_servicemanager.sh"
		destination = "/home/ubuntu/AE/install_agent_servicemanager.sh"
	
		connection {
			type        = "ssh"
			user        = "ubuntu"
			private_key = "${file("./nguta04.pem")}"
		}
	}
	
	provisioner "remote-exec" {
		inline = [
			"chmod +x /home/ubuntu/AE/install_agent_servicemanager.sh",
			"/home/ubuntu/AE/install_agent_servicemanager.sh ${var.agent_name} ${var.ae_host} ${var.ae_port} ${var.sm_port}"
		]
		
		connection {
			type        = "ssh"
			user        = "ubuntu"
			private_key = "${file("./nguta04.pem")}"
		}
	}
}

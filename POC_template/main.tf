provider "aws" {
	region     = "ap-southeast-1"
	access_key = "${var.aws_access}"
	secret_key = "${var.aws_secret}"
}

resource "aws_instance" "nguta04_sample" {
	ami                    = "ami-6378f600"
	instance_type          = "t2.micro"
//	vpc_security_group_ids = ["sg-03c984013c3969e2a"]
	key_name               = "nguta04"

	tags {
		Name = "nguta04_machine"
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
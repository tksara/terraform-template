provider "aws" {
	region     = "us-east-2"
	access_key = "${var.aws_access_key}"
	secret_key = "${var.aws_secret_key}"
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



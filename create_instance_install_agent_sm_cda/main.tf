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

	provisioner "local-exec" {
		working_dir = "${var.local_scripts_location}"
		command = "./create_cda_dpltarget.sh \"${var.cda_host}\" \"${var.cda_user}\" \"${var.cda_pass}\" \"${var.agent_name_prefix}${random_string.cda_entity_name.result}\" \"${var.depltarget_prefix}${random_string.cda_entity_name.result}\" \"${aws_instance.cda_instance.public_ip}\" \"${var.tomcat_home_dir}\" \"${var.tomcat_user}\" \"${var.tomcat_pass}\" \"${var.cda_folder}\""
	}

	provisioner "local-exec" {
		working_dir = "${var.local_scripts_location}"
		command = "./create_cda_environment.sh \"${var.cda_host}\" \"${var.cda_user}\" \"${var.cda_pass}\" \"${var.depltarget_prefix}${random_string.cda_entity_name.result}\" \"${var.cda_folder}\" \"${var.environment_prefix}${random_string.cda_entity_name.result}\""
	}
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
}
*/
resource "random_string" "cda_entity_name" {
	length  = 10
	special = false
	lower   = false
}

output "public_ip" {
	value = "${aws_instance.cda_instance.public_ip}"
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

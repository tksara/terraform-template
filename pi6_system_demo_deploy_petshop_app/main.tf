variable "aws_access_key" {}
variable "aws_secret_key" {}
//variable "aws_ami" {default = "ami-0080e4c5bc078760e"}
variable "aws_ami" {default = "ami-04b9e92b5572fa0d1"}
variable "aws_security_group_id" {default = "sg-495c840a"}
variable "instance_type" {default = "t2.micro"}
//variable "cda_server" {default = "http://STOZH01L7480/cda"}
variable "cda_server" {default = "http://vviedev01.sbb01.spoc.global/cda"}
variable "cda_user" {default = "100/BOND/AUTOMIC"}
variable "cda_password" {default = "bond"}
//variable "remote_working_dir" {default = "/home/ec2-user/AE"}
variable "remote_working_dir" {default = "/home/ubuntu/AE"}
variable "private_key_file" {default = "C:\\Terraform\\EM\\AWS_Key\\jeny-key-us-east-1.pem"}
variable "package" {default = "no-package"}

provider "aws" {
  region     = "us-east-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_instance" "cda_instance" {
  ami                    = "${var.aws_ami}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${var.aws_security_group_id}"]
  key_name	         = "jeny-key-us-east-1"
	
  tags = {
    Name = "pet-shop-prod"
  }
  
  provisioner "remote-exec" {
	inline = [
		"mkdir -p ${var.remote_working_dir}",
		"mkdir -p ${var.remote_working_dir}/scripts"
	]

	connection {
		type        = "ssh"
		host        = self.public_ip 
		user        = "ubuntu"
		private_key = "${file("${var.private_key_file}")}"
	}
  }

  provisioner "file" {
	source      = "artifacts"
	destination = "${var.remote_working_dir}"

	connection {
		type        = "ssh"
                host        = self.public_ip
		user        = "ubuntu"
		private_key = "${file("${var.private_key_file}")}"
	}
  }

  provisioner "file" {
	source      = "scripts/agent_installation.sh"
	destination = "${var.remote_working_dir}/scripts/agent_installation.sh"

	connection {
		type        = "ssh"
                host        = self.public_ip
		user        = "ubuntu"
		private_key = "${file("${var.private_key_file}")}"
	}
  }

  provisioner "file" {
	source      = "scripts/tomcat_installation.sh"
	destination = "${var.remote_working_dir}/scripts/tomcat_installation.sh"

	connection {
		type        = "ssh"
                host        = self.public_ip
		user        = "ubuntu"
		private_key = "${file("${var.private_key_file}")}"
	}
  }

  provisioner "remote-exec" {
	inline = [
		"chmod +x ${var.remote_working_dir}/scripts/tomcat_installation.sh",
		"${var.remote_working_dir}/scripts/tomcat_installation.sh ${var.tomcat_user} ${var.tomcat_pass}"
	]

	connection {
		type        = "ssh"
                host        = self.public_ip
		user        = "ubuntu"
		private_key = "${file("${var.private_key_file}")}"
	}
  }

  provisioner "remote-exec" {
	inline = [
		"chmod +x ${var.remote_working_dir}/scripts/agent_installation.sh",
		"${var.remote_working_dir}/scripts/agent_installation.sh ${var.agent_name_prefix}${random_string.cda_entity_name.result} ${var.ae_host} ${var.ae_port} ${var.sm_port} ${var.agent_pass} \"${var.remote_working_dir}\" ${self.public_ip}"
	]

	connection {
		type        = "ssh"
              //  host        = "${aws_instance.cda_instance.public_ip}"
                host        = self.public_ip
		user        = "ubuntu"
		private_key = "${file("${var.private_key_file}")}"
	}
  }	
}

resource "random_string" "cda_entity_name" {
	length  = 10
	special = false
	lower   = false
}

provider "cda" {
  cda_server     = "${var.cda_server}"
  user           = "${var.cda_user}"
  password       = "${var.cda_password}"  
	
  default_attributes = { // default_attributes can be used to set the 'folder' and 'owner' attributes globally for the template.
    folder = "DEFAULT"
    owner  = "100/BOND/AUTOMIC"
  }
}
 
resource "cda_environment" "demoEnvironment" {
  name               = "${aws_instance.cda_instance.tags.Name}-${local.id}"
  type               = "Production"
  
  deployment_targets = ["${cda_deployment_target.demoTarget.name}"]
}

resource "cda_deployment_target" "demoTarget" {
  name        = "Tomcat-${local.id}"
  type        = "Tomcat"
  agent       = "${var.agent_name_prefix}${random_string.cda_entity_name.result}"
	
   dynamic_properties = {
      "instance_ip" = "${aws_instance.cda_instance.public_ip}"
  }
}

resource "cda_login_object" "demoLoginObject" {
  name        = "demoLoginObject-${local.id}"

  credentials = [
    {
      agent      = "*"
      type       = "UNIX"
      username   = "${var.agent_user}"
      password   = "${var.agent_pass}"
    }
  ]
}

resource "cda_deployment_profile" "demoDeploymentProfile" {
  name         = "demoProfile-${local.id}"
  application  = "Demo_RepoApp"
  environment  = "${cda_environment.demoEnvironment.name}"
  login_object = "${cda_login_object.demoLoginObject.name}"

  deployment_map = {
    "petstore" = "${cda_deployment_target.demoTarget.name}"
  }
}

resource "cda_workflow_execution" "my_execution" {
  triggers                     = "true"
  application                  = "Demo_RepoApp" 
  workflow                     = "Deploy" 
  package                      = "${var.package}" 
  deployment_profile           = "${cda_deployment_profile.demoDeploymentProfile.name}" 
  override_existing_components = "false"	
}
	
locals {
	id = "${random_integer.name_extension.result}"
}

resource "random_integer" "name_extension" {
  min     = 1
  max     = 99999
}
	
output "internal_ip_output" {
	description = "package name"
	value       = "${var.package}"
}	

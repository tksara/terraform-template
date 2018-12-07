provider "aws" {
	region     = "us-east-2"
	access_key = "${var.aws_access_key}"
	secret_key = "${var.aws_secret_key}"
}



resource "aws_instance" "cda_instance" {
	ami                    = "${var.aws_ami}"
	instance_type          = "t2.micro"
	vpc_security_group_ids = ["${var.aws_security_group_id}"]
//	vpc_security_group_ids = "alabala"
//	key_name	       = "${var.aws_key_name}"
	key_name	= "jeny-key"
	user_data = <<HEREDOC
		#!/bin/bash
		yum update -y
		yum install -y docker
		service docker start
		usermod -aG docker ec2-user
		curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose	
		chmod +x /usr/local/bin/docker-compose
		sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
		docker-compose --version
		yum install -y git
		mkdir  /tmp/jenya
                cd /tmp/jenya
		git clone git://github.com/jenyss/requestbin.git
		cd requestbin
		docker-compose build
		docker-compose up -d
	HEREDOC
}

output "public_ip" {
	description = "List of public IP addresses assigned to the instances, if applicable"
	value = "${aws_instance.cda_instance.*.public_ip[0]}"
}

module "consul" {
	source = "curl -L -o /usr/local/bin/terraform-provider-sendmail https://github.com/roboll/terraform-provider-sendmail/releases/download/{VERSION}/terraform-provider-sendmail_{OS}_{ARCH}"
}

resource sendmail_send email {
	from = "someone@example.com"
	to = "otherone@example.com"
	subject = "A Terraform Email"
	body = <<EMAIL
Hello, this is an email from terraform {{${aws_instance.cda_instance.*.public_ip[0]}}}
EMAIL
}


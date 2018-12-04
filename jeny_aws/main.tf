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
		amazon-linux-extras install docker
		service docker start
		usermod -aG docker ec2-user
	HEREDOC
}	

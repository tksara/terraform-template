variable "access_key" {}
variable "secret_key" {}
variable "aws_ami" {default = "ami-0080e4c5bc078760e"}
variable "aws_security_group_id" {}
variable "instance_type" {default = "t2.micro"}

provider "aws" {
  region     = "us-east-1"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

resource "aws_instance" "cda_instance" {
  ami                    = "${var.aws_ami}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${var.aws_security_group_id}"]
  //key_name	= "jeny-key-us-east-1"
}

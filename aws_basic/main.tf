variable "access_key" {}
variable "secret_key" {}
variable "aws_ami" {default = "ami-03c3a7e4263fd998c"}
variable "aws_security_group_id" {default = "sg-730e980c"}
variable "instance_type" {default = "t2.micro"}

provider "aws" {
  region     = "eu-central-1"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

resource "aws_instance" "cda_instance" {
  ami                    = "${var.aws_ami}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${var.aws_security_group_id}"]
  key_name	             = "im-aws"
}

variable "var1" {}
variable "var2" {}
variable "aws_ami" {default = "ami-03c3a7e4263fd998c"}
variable "aws_security_group_id" {default = "sg-730e980c"}
variable "instance_type" {default = "t2.micro"}

provider "aws" {
  region     = "eu-central-1"
  access_key = "${var.var1}"
  secret_key = "${var.var2}"
}

resource "aws_instance" "cda_instance" {
  ami                    = "${var.aws_ami}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${var.aws_security_group_id}"]
  key_name	             = "im-aws"
}

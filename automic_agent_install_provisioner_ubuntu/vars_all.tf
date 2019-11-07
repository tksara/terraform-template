variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_ami" {default = "ami-04b9e92b5572fa0d1"}
variable "aws_security_group_id" {default = "sg-495c840a"}
variable "instance_type" {default = "t2.micro"}
variable "cda_server" {default = "http://STOZH01L7480/cda"}
variable "cda_user" {default = "100/AUTOMIC/AUTOMIC"}
variable "cda_password" {}
variable "remote_working_dir" {default = "/home/ubuntu/AE"}
variable "private_key_file" {default = "C:\\Terraform\\EM\\AWS_Key\\jeny-key-us-east-1.pem"}
variable "agent_port" {}
variable "ae_system_name" {}
variable "ae_host" {default = "3.88.27.73"}
variable "ae_port" {}
variable "sm_host" {}
variable "sm_port" {}
variable "sm_name" {}

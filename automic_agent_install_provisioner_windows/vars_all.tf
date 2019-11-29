variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_ami" {default = "ami-04b9e92b5572fa0d1"}
variable "aws_security_group_id" {default = "sg-495c840a"}
variable "instance_type" {default = "t2.micro"}
variable "remote_working_dir" {default = "/home/ubuntu/AE"}
variable "private_key_file" {default = "C:\\Terraform\\EM\\AWS_Key\\jeny-key-us-east-1.pem"}
variable "agent_port" {default = "2300"}
variable "ae_system_name" {default = "AUTOMIC"}
variable "ae_host" {default = "3.88.27.73"}
variable "ae_port" {default = "2217"}
variable "sm_port" {default = "8871"}
variable "sm_name" {default = "sm_"}
variable "agent_user" {default = "Administrator"}
variable "agent_pass" {default = ""}

variable "cda_host" {
	default = "http://10.131.39.166/cda" # format <http or https>://<cda_host or cda_ip>/cda_name
}

variable "cda_user" {
	default = "100/AUTOMIC/AUTOMIC"
}

variable "cda_pass" {
	default = "automic"
}

variable "cda_folder" {
	default = "DEFAULT"
}

variable "depltarget_prefix" {
	default = "Terraform_Target_"
}

variable "environment_prefix" {
	default = "Terraform_Env_"
}

variable "login_object_prefix" {
	default = "LoginObjectForTerraformTarget_"
}

variable "profile_prefix" {
	default = "Terraform_Profile_"
}

variable "application" {
	default = "Terraform App.1"
}

variable "package" {
	default = "Pack Web"
}

variable "workflow" {
	default = "Deploy"
}


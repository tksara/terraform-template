variable "agent_name_prefix" {
	default = "UNIX_TERRAFORM_"
}

variable "agent_user" {
	//default = "ubuntu"
	default = "ec2-user"
}

variable "agent_pass" {
	default = "ubuntu"
}

variable "sm_port" {
	default = "8871"
}

variable "ae_host" {
	default = "172.31.43.107" # Private IP of Proxy Server
}

variable "ae_port" {
	default = "2217"
}

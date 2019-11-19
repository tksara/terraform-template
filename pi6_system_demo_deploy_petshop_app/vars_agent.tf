variable "agent_name_prefix" {
	default = "UNIX_TERRAFORM_"
}

variable "agent_user" {
	default = "ubuntu"
	//default = "ec2-user"
}

variable "agent_pass" {
	default = "ubu123A-ntu"
}

variable "sm_port" {
	default = "8871"
}

variable "ae_host" {
	//default = "172.31.43.107" # Private IP of Proxy Server
	//default = "34.204.2.38" # Proxy Agent VM Public IP
	default = "3.83.203.164"
	//default = "172.31.90.97" # Proxy Agent VM Private IP
}

variable "ae_port" {
	default = "2217"	
}

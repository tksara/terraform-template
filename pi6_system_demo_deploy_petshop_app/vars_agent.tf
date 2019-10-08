variable "agent_name_prefix" {
	default = "UNIX_TERRAFORM_"
}

variable "agent_user" {
	default = "ubuntu"
}

variable "agent_pass" {
	default = "ubuntu"
}


variable "ae_host" {
	default = "172.31.43.107" # Private IP of Proxy Server
}

variable "ae_port" {
	default = "2217"
}

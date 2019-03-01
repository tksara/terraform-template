variable "agent_name_prefix" {
	default = "UNIX_TERRAFORM_"
}

variable "agent_user" {
	default = "automic"
}

variable "agent_pass" {
	default = "automic"
}


variable "ae_host" {
	default = "10.243.44.139" # Private IP of Proxy Server
}

variable "ae_port" {
	default = "2217"
}

variable "sm_port" {
	default = "8871"
}

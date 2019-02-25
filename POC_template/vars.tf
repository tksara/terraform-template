variable "aws_access" {
	default = ""
}

variable "aws_secret" {
	default = ""
}

variable "agent_name" {
	default = "UNIX_TERRAFORM_01"
}

variable "ae_host" {
	default = "172.31.43.107" # Private IP of Proxy Server
}

variable "ae_port" {
	default = "2217" # AE Port
}

variable "sm_port" {
	default = "8871"
}

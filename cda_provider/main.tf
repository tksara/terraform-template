variable "cda_server" {default = ""}
variable "cda_user" {default = ""}
variable "cda_password" {default = ""}

provider "cda" {
  cda_server     = "${var.cda_server}"
  user           = "${var.cda_user}"
  password       = "${var.cda_password}"  
}
 
resource "cda_environment" "firstEnvironment" {
  name               = "jeny_test_1"
  folder             = "DEFAULT"
  custom_type        = "Generic"
  description        = "Description Update"
  owner              = "100/AUTOMIC/AUTOMIC"
}

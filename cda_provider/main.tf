variable "cda_server" {default = "http://10.55.11.196/cda"}
variable "cda_user" {default = "100/AUTOMIC/AUTOMIC"}
variable "cda_password" {default = ""}

provider "cda" {
  cda_server     = "${var.cda_server}"
  user           = "${var.cda_user}"
  password       = "${var.cda_password}"  
}
 
resource "cda_environment" "firstEnvironment" {
  name               = "jeny_test_41"
  folder             = "DEFAULT"
  custom_type        = "Production"
  description        = "Description Update"
  owner              = "100/AUTOMIC/AUTOMIC"
  
  dynamic_properties = {
      "name1" = "value1"
      "name2" = "value2"
  }
  
  custom_properties = {}
  
  deployment_targets = []
}

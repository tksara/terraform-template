//variable "cda_server" {default = "http://10.55.19.254/cda"}
variable "cda_server" {default = "http://STOZH01L7480/cda"}
//variable "cda_server" {default = "http://STOZH01L7480:80/cda"}
variable "cda_user" {default = "100/AUTOMIC/AUTOMIC"}
variable "cda_password" {default = ""}
variable "component_name" {default = "Component A"}

locals {
	id = "${random_integer.name_extension.result}"
}

resource "random_integer" "name_extension" {
  min     = 1
  max     = 99999
}

provider "cda" {
  cda_server     = "${var.cda_server}"
  user           = "${var.cda_user}"
  password       = "${var.cda_password}"  
}
/* 
resource "cda_environment" "firstEnvironment" {
  name               = "jeny-${local.id}"
  folder             = "DEFAULT"
  type               = "Generic"
  description        = "Description Update"
  owner              = "100/AUTOMIC/AUTOMIC"
  
  dynamic_properties = {
      "name1" = "value1"
      "name2" = "value2"
  }
  
  custom_properties = {}
  
  deployment_targets = ["${cda_deployment_target.jenys_target.name}", "Local Tomcat"]
}

resource "cda_deployment_target" "jenys_target" {
  name        = "jeny-${local.id}"
  type        = "Database JDBC"
  folder      = "DEFAULT"
  owner       = "100/AUTOMIC/AUTOMIC"
  //agent       = "WIN01"
}

resource "cda_login_object" "my_login_object" {
  name        = "test_login_object-${local.id}"
  folder      = "DEFAULT"
  owner       = "100/AUTOMIC/AUTOMIC"

  credentials = [
    {
      agent      = "*"
      type       = "WINDOWS"
      username   = "Agent_User"
      password   = "automic"
    }
  ]
}

resource "cda_deployment_profile" "my_deployment_profile" {
  name         = "test_profile-${local.id}"
  folder       = "DEFAULT"
  owner        = "100/AUTOMIC/AUTOMIC"
  application  = "IM Test App"
  environment  = "${cda_environment.firstEnvironment.name}"
  login_object = "${cda_login_object.my_login_object.name}"

  deployment_map = {
    "${var.component_name}" = "${cda_deployment_target.jenys_target.name}, Local Tomcat"
    "Component B" = "Local Tomcat"
  }
}
*/
resource "cda_workflow_execution" "my_execution" {
  triggers = false
  application                  = "DemoApp" 
  workflow                     = "deploy" 
  package                      = "1" 
  deployment_profile           = "Local" 
  //manual_approval              = "true" 
  //approver                     = "100/AUTOMIC/AUTOMIC"
  //schedule                     = "2019-12-28T13:44:00Z" //"cron(0 3 12 12 ? 2019)" //start_date = "2019-12-12" //start_time = "3:00"  
  //override_existing_components = "true"
}

output "installtion_url" {
  value = cda_workflow_execution.my_execution.installation_url
}

output "monitor_url" {
  value = cda_workflow_execution.my_execution.monitor_url
}

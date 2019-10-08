variable "cda_server" {default = "http://STOZH01L7480/cda"}
variable "cda_user" {default = "100/AUTOMIC/AUTOMIC"}
variable "cda_password" {default = ""}

provider "cda" {
  cda_server     = "${var.cda_server}"
  user           = "${var.cda_user}"
  password       = "${var.cda_password}"  
	
  default_attributes = { // default_attributes can be used to set the 'folder' and 'owner' attributes globally for the template.
    folder = "DEFAULT"
    owner  = "100/AUTOMIC/AUTOMIC"
  }
}
 
resource "cda_environment" "demoEnvironment" {
  name               = "Pet Shop PROD"
  folder             = "DEFAULT"
  
  deployment_targets = ["${cda_deployment_target.jenys_target.name}", "Local Tomcat"]
}

resource "cda_deployment_target" "jenys_target" {
  name        = "jeny-${local.id}"
  type        = "Database JDBC"
  agent       = "WIN01" //TODO Install the Agent
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
  application  = "IM Test App"
  environment  = "${cda_environment.firstEnvironment.name}"
  login_object = "${cda_login_object.my_login_object.name}"

  deployment_map = {
    "${var.component_name}" = "${cda_deployment_target.jenys_target.name}, Local Tomcat"
    "Component B" = "Local Tomcat"
  }
}

resource "cda_workflow_execution" "my_execution" {
  triggers                     = "true"
  application                  = "application" 
  workflow                     = "workflow name" 
  package                      = "package" 
  deployment_profile           = "my_deployment_profile" 
  override_existing_components = "false"
}

variable "client_secret" {}
variable "subscription_id" {}
variable "client_id" {}
variable "tenant_id" {}

provider "azurerm" {

	subscription_id = "${var.subscription_id}"
	client_id       = "${var.client_id}"
	client_secret   = "${var.client_secret}"
	tenant_id       = "${var.tenant_id}"
}

resource "azurerm_resource_group" "test" {
	name = "test_group"
	location = "East US"
}

resource "azurerm_virtual_network" "test_instance" {
	address_space = ["10.0.0.0/16"]
	location = "${azurerm_resource_group.test.location}}"
	name = "test_instance"
	resource_group_name = "${azurerm_resource_group.test.name}"
}

resource "azurerm_subnet" "internal" {
	name                 = "internal"
	resource_group_name  = "${azurerm_resource_group.test.name}"
	virtual_network_name = "${azurerm_virtual_network.test_instance.name}"
	address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "test_instance" {
	name                = "network_interface"
	location            = "${azurerm_resource_group.test.location}"
	resource_group_name = "${azurerm_resource_group.test.name}"

	ip_configuration {
		name                          = "testconfiguration1"
		subnet_id                     = "${azurerm_subnet.internal.id}"
		private_ip_address_allocation = "dynamic"
	}
}

resource "azurerm_virtual_machine" "main" {
	name = "test-vm"
	location = "${azurerm_resource_group.test.location}"
	resource_group_name = "${azurerm_resource_group.test.name}"
	network_interface_ids = [
		"${azurerm_network_interface.test_instance.id}"]
	vm_size = "Standard_DS1_v2"

	storage_os_disk {
		name              = "myosdisk1"
		caching           = "ReadWrite"
		create_option     = "FromImage"
		managed_disk_type = "Standard_LRS"
	}
}

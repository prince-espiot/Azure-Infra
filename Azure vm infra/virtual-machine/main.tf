variable "vm_name" {}
variable "vm_size" {}

variable "location" {}
variable "resource_group_name" {}
variable "public_key" {}
variable "subnet_id" {}
variable "network_security_group_id" {}
variable "network_interface_ids" {}
variable "enable_public_ip" {}
variable "user_data_install_apache" {}

output "vm_id" {
  value = azurerm_virtual_machine.vm.id
}

output "vm_public_ip" {
  value = azurerm_public_ip.vm_public_ip.ip_address
}

resource "azurerm_public_ip" "vm_public_ip" {
  count               = var.enable_public_ip ? 1 : 0
  name                = "${var.vm_name}-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

#set up the network interface
resource "azurerm_network_interface" "smart" {
    name                = "smart-nic"
    count = length(azurerm_subnet.Dev_project_public_subnet)
    location            = var.location
    resource_group_name = var.resource_group_name

    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.Dev_project_public_subnet[0].id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = var.enable_public_ip ? azurerm_public_ip.vm_public_ip[0].id : null
    }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = var.network_interface_ids
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "${var.vm_name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }


  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }


  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Name = var.vm_name
  }
}


resource "azure_virtual_machine_extension" "customextension" {
  name                 = "customScript"
  virtual_machine_id   = azurerm_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  protected_settings  = <<PROT
    {
        "script": "${base64encode(file("${path.module}/template/install_apache.sh"))}"
    }
  PROT
  depends_on = [ azurerm_virtual_machine.vm ]
}
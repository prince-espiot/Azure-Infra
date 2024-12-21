variable "vm_name" {}
variable "vm_size" {}
variable "admin_username" {}
variable "admin_password" {}
variable "location" {}
variable "resource_group_name" {}
variable "public_key" {}
variable "subnet_id" {}
variable "network_security_group_id" {}
variable network_interface_ids {}
variable "enable_public_ip" {}
variable "user_data_install_apache" {}

#output "ssh_connection_string_for_vm" {
#    value = var.enable_public_ip ? format("ssh -i /home/ubuntu/keys/azure_vm_terraform %s@%s", var.admin_username, azurerm_public_ip.vm_public_ip.ip_address) : ""
#}

output "vm_id" {
    value = azurerm_virtual_machine.vm.id
}

#output "public_ip" {
#    value       = azurerm_public_ip.vm_public_ip.ip_address
#    description = "The public IP address of the Azure VM."
#}

resource "azurerm_public_ip" "vm_public_ip" {
    count              = var.enable_public_ip ? 1 : 0
    name               = "${var.vm_name}-public-ip"
    location           = var.location
    resource_group_name = var.resource_group_name
    allocation_method  = "Dynamic"
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

    os_profile {
        computer_name  = var.vm_name
        admin_username = var.admin_username
        admin_password = var.admin_password
        custom_data    = var.user_data_install_apache
        
    }

    os_profile_linux_config {
        disable_password_authentication = false
        
    }

    tags = {
        Name = var.vm_name
    }
}
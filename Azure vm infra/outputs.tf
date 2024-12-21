output "resource_group_name" {
    description = "The name of the resource group"
    value       = azurerm_resource_group.rg.name
}

output "location" {
    description = "The location of the resource group"
    value       = azurerm_resource_group.rg.location
}

output "vnet_name" {
    description = "The name of the virtual network"
    value       = azurerm_virtual_network.smartvnet.name
}

output "vnet_cidr" {
    description = "The CIDR block for the virtual network"
    value       = azurerm_virtual_network.smartvnet.address_space
}

output "subnet_name" {
    description = "The name of the public subnet"
    value       = azurerm_subnet.Dev_project_public_subnet.*.name
}

output "cidr_public_subnet" {
    description = "CIDR block for the public subnet"
    value       = azurerm_subnet.Dev_project_public_subnet.*.address_prefixes
}


output "private_subnet_name" {
    description = "The name of the private subnet"
    value       = azurerm_subnet.smartprivatesnet.*.name
}
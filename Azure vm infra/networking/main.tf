variable "vnet_cidr" {}
variable "vnet_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "cidr_public_subnet" {}
variable "cidr_private_subnet" {}
variable "subnet_name" {}
variable "private_subnet_name" {}
  

output "Dev_project_vnet" {
    value = azurerm_virtual_network.smartvnet.name  
}

output "Dev_project_public_subnet" {
    value = azurerm_subnet.Dev_project_public_subnet.*.id
}

output "Dev_project_cidr_block" {
    value = azurerm_subnet.Dev_project_public_subnet.*.address_prefixes
}

output "location" {
    value = azurerm_resource_group.smart.location
  
}

output "resource_group_name" {
    value = azurerm_resource_group.smart.name
}

# resource location
resource "azurerm_resource_group" "smart" {
    name     = var.resource_group_name
    location = var.location
}

#set up the virtual network
resource "azurerm_virtual_network" "smartvnet" {
    name                = var.vnet_name
    address_space       = [var.vnet_cidr]
    location            = var.location
    resource_group_name = var.resource_group_name
}

#set up the public subnet
resource "azurerm_subnet" "Dev_project_public_subnet" {
    count               = length(var.cidr_public_subnet)
    name                = "${var.subnet_name}-${count.index}"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.smartvnet.name
    address_prefixes    = [element(var.cidr_public_subnet, count.index)]
}
#set up the private subnet
resource "azurerm_subnet" "smartprivatesnet" {
    count               = length(var.cidr_private_subnet)
    name                = "${var.private_subnet_name}-${count.index}"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.smartvnet.name
    address_prefixes    = [element(var.cidr_private_subnet, count.index)]
}

#set up route table for the private subnet
resource "azurerm_route_table" "smartprivateroutetable" {
    name                = "smart-private-route-table"
    resource_group_name = azurerm_resource_group.smart.name
    location            = azurerm_resource_group.smart.location
}

#set up route table association for the private subnet
resource "azurerm_subnet_route_table_association" "smartprivateroutetableassociation" {
    count = length(azurerm_subnet.smartprivatesnet)
    subnet_id      = azurerm_subnet.smartprivatesnet[count.index].id
    route_table_id = azurerm_route_table.smartprivateroutetable.id
}

#set route table for public subnet
resource "azurerm_route_table" "smartroutetable" {
    name                = "smart-route-table"
    resource_group_name = azurerm_resource_group.smart.name
    location            = azurerm_resource_group.smart.location
}

#set up route table association for public subnet
resource "azurerm_subnet_route_table_association" "smartroutetableassociation" {
    count = length(azurerm_subnet.Dev_project_public_subnet)
    subnet_id      = azurerm_subnet.Dev_project_public_subnet[count.index].id
    route_table_id = azurerm_route_table.smartroutetable.id
}

#set up the network interface
resource "azurerm_network_interface" "smart" {
    name                = "smart-nic"
    count = length(azurerm_subnet.Dev_project_public_subnet)
    location            = azurerm_resource_group.smart.location
    resource_group_name = azurerm_resource_group.smart.name

    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.Dev_project_public_subnet[0].id
        private_ip_address_allocation = "Dynamic"
    }
}
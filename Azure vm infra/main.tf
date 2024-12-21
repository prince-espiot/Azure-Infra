module "networking" {
    source = "./networking"
    resource_group_name = var.resource_group_name
    location            = var.location
    vnet_name           = var.vnet_name
    vnet_cidr           = var.vnet_cidr
    subnet_name         = var.subnet_name
    cidr_public_subnet  = var.cidr_public_subnet
    private_subnet_name = var.private_subnet_name
    cidr_private_subnet = var.cidr_private_subnet
}

module "network_security_group" {
  source                     = "./security-groups"
  nsg_name                   = "NSG for VMs to enable SSH(22) and HTTP(80)"
  resource_group_name        = var.resource_group_name 
  location                   = var.location          
  source_address_prefix    = tolist(module.networking.Dev_project_cidr_block )    
}

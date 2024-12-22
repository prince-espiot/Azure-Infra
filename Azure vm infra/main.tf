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
  nsg_name                   = "nsg-vm-ssh-http"
  resource_group_name        = module.networking.resource_group_name
  location                   = module.networking.location         
  source_address_prefix    = tolist(module.networking.Dev_project_cidr_block )    
}

module "virtual_machine" {
    source = "./virtual-machine"
    vm_name = var.vm_name
    vm_size = var.vm_size
    location = module.networking.location
    resource_group_name = module.networking.resource_group_name
    network_interface_ids = [azurerm_network_interface.smart.id]
    public_key = var.public_key
    subnet_id = module.networking.Dev_project_public_subnet[0]
    network_security_group_id = module.network_security_group.nsg_id
    enable_public_ip = true
    user_data_install_apache = file("./template/ec2_install_apache.sh")
  
}
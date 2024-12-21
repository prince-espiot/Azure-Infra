variable "resource_group_name" {
    type        = string
    description = "Name of the resource group"
}

variable "location" {
    type        = string
    description = "Azure region where resources will be deployed"
}

variable "vnet_name" {
    type        = string
    description = "Name of the virtual network"
}

variable "vnet_cidr" {
    description = "The CIDR block for the virtual network"
    type        = string
    default     = "10.0.0.0/16"
}

variable "subnet_name" {
    type        = string
    description = "Name of the public subnet"
}

variable "cidr_public_subnet" {
    type        = list(string)
    description = "CIDR block for the public subnet"
}

variable "private_subnet_name" {
    type        = string
    description = "Name of the private subnet"
}

variable "cidr_private_subnet" {
    type        = list(string)
    description = "CIDR block for the private subnet"
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = list(string)
}


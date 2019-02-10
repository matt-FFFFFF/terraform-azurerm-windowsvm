variable name_prefix {
  description = "Prefix of the VM name"
  default     = "windows"
}

variable os_sku {
  description = "Sku of Windows VM"
  default     = "2019-Datacenter"
}

variable admin_password {
  description = "Admin password for VM"
  default = ""
}

variable admin_username {
  description = "Admin password for VM"
  default = ""
}

variable timezone {
  description = "Timezone of the Windows VM"
  default = "GMT Standard Time"
}

variable vm_sku {
  default = "VM size"
  default = "Standard_B2ms"
}

variable number_of_instances {
  description = "How many instances are requried"
  default     = 1
}

variable "resource_group_name" {
  description = "Default resource group name that the network will be created in"
  default     = "rg123"
}

variable "location" {
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  default     = "westeurope"
}

variable "subnet_name" {
  description = "Name of the subnet"
  default     = "subnet123"
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  default     = "vnet123"
}

variable "virtual_network_resource_group_name" {
  description = "Name of the virtual network resource group"
  default     = "rg123"
}

variable key_vault_name {
  description = "Name of the keyVault"
  default     = "kv123"
}

variable key_vault_resource_group_name {
  description = "Resource group of the keyVault"
  default     = "rg123"
}

variable key_encryption_key_url {
  description = "URL to key encryption key - only requried if using KEK"
  default     = ""
}

variable encryption_algorithm {
  description = " Algo for encryption"
  default     = "RSA-OAEP"
}

variable "volume_type" {
  default = "All"
}

variable "encrypt_operation" {
  default = "EnableEncryption"
}

variable "type_handler_version" {
  description = "Type handler version of the VM extension to use. Defaults to 2.2 on Windows and 1.1 on Linux"
  default     = "2.2"
}

variable "tags" {
  description = "The tags to associate with your resources"
  type        = "map"

  default = {}
}

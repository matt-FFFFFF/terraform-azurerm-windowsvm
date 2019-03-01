data "azurerm_resource_group" "rg" {
  name = "${var.resource_group_name}"
}

data "azurerm_virtual_network" "vnet" {
  name                = "${var.virtual_network_name}"
  resource_group_name = "${var.virtual_network_resource_group_name}"
}

data "azurerm_subnet" "subnet" {
  name                 = "${var.subnet_name}"
  virtual_network_name = "${var.virtual_network_name}"
  resource_group_name  = "${var.virtual_network_resource_group_name}"
}

data "azurerm_key_vault" "keyvault" {
  name                = "${var.key_vault_name}"
  resource_group_name = "${var.key_vault_resource_group_name}"
}

resource "azurerm_virtual_machine" "vm" {
  name                             = "${var.name_prefix}${format("%03d", count.index + 1)}"
  count                            = "${var.number_of_instances}"
  location                         = "${data.azurerm_resource_group.rg.location}"
  resource_group_name              = "${var.resource_group_name}"
  network_interface_ids            = ["${element(azurerm_network_interface.vm.*.id, count.index)}"]
  vm_size                          = "${var.vm_sku}"
  zones                            = ["${(count.index % 3) + 1 }"]
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "${var.os_sku}"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.name_prefix}${format("%03d", count.index + 1)}-disk0"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  os_profile {
    computer_name  = "${var.name_prefix}${format("%03d", count.index + 1)}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_windows_config {
    provision_vm_agent = true
    timezone           = "${var.timezone}"
  }

  tags = "${var.tags}"
}

resource "azurerm_network_interface" "vm" {
  name                = "${var.name_prefix}${format("%03d", count.index + 1)}-nic0"
  count               = "${var.number_of_instances}"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "ip0"
    subnet_id                     = "${data.azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine_extension" "vmextension" {
  count                      = "${var.number_of_instances}"
  name                       = "AzureDiskEncryption"
  location                   = "${data.azurerm_resource_group.rg.location}"
  resource_group_name        = "${data.azurerm_resource_group.rg.name}"
  virtual_machine_name       = "${element(azurerm_virtual_machine.vm.*.name, count.index)}"
  publisher                  = "Microsoft.Azure.Security"
  type                       = "AzureDiskEncryption"
  type_handler_version       = "${var.type_handler_version}"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "EncryptionOperation": "${var.encrypt_operation}",
        "KeyVaultURL": "${data.azurerm_key_vault.keyvault.vault_uri}",
        "KeyVaultResourceId": "${data.azurerm_key_vault.keyvault.id}",					
        "KeyEncryptionKeyURL": "${var.key_encryption_key_url}",
        "KekVaultResourceId": "${data.azurerm_key_vault.keyvault.id}",					
        "KeyEncryptionAlgorithm": "${var.encryption_algorithm}",
        "VolumeType": "${var.volume_type}"
    }
SETTINGS

  tags = "${var.tags}"
}

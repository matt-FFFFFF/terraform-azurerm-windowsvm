# Azure Windows VM

Creates a Windows VM with the following configuration:

* Uses the public gallery image published by Microsoft

* Managed Disk with Premium Storage

* Azure Disk Encryption is enabled

* Supports creating multiple instances, will add zero padded number to the end of the supplied name prefix

* Will deploy in Availability Zones

## Usage

```hcl
module "windowsvm" {
  source = "github.com/matt-FFFFFF/terraform-modules//Azure/windowsvm/azurerm?ref=master"
  admin_password = "mysecretpassword"
  admin_username = "myusername"
  resource_group_name = "myrg"
  location = "westeurope"
  subnet_name = "mysubnet"
  virtual_network_name = "myvnet"
  virtual_network_resource_group_name = "myvnetrg"
  key_vault_name = "mykv"
  key_vault_resource_group_name = "mykvrg"
  number_of_instances = 3
  vm_sku = "Standard_B2ms"
  tags = {
    mytag = "myvalue"
  }
}
```
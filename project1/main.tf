
resource "azurerm_resource_group" "rg-vineet-01" {
        name = "rg-${var.business_unit}-${var.enivornment}-${var.rg-name}"
        location = var.location
}

resource "azurerm_virtual_network" "vnet1" {
  name = "vnet-${var.business_unit}-${var.enivornment}-${var.vnet-name}"
  resource_group_name = azurerm_resource_group.rg-vineet-01.name
  location = azurerm_resource_group.rg-vineet-01.location
  address_space = var.vnetip
}

resource "azurerm_subnet" "subnet1" {
   name = "subnet-${var.business_unit}-${var.enivornment}-${var.vnet-name}"
   virtual_network_name = azurerm_virtual_network.vnet1.name
  resource_group_name = azurerm_resource_group.rg-vineet-01.name
  address_prefixes = var.subnetip
  
}

resource "azurerm_public_ip" "public-ip"{
  name = "pip-${var.business_unit}-${var.enivornment}"
   resource_group_name = azurerm_resource_group.rg-vineet-01.name
  location = azurerm_resource_group.rg-vineet-01.location
  allocation_method = "Static" 
}

resource "azurerm_network_interface" "nic" {
  name = "nic-${var.business_unit}-${var.enivornment}"
  resource_group_name = azurerm_resource_group.rg-vineet-01.name
  location = azurerm_resource_group.rg-vineet-01.location

  ip_configuration {
    name = "ip-${var.business_unit}-${var.enivornment}"
    subnet_id = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    
}
}

resource "azurerm_linux_virtual_machine" "linuxvm" {
name = "vm-${var.business_unit}-${var.enivornment}"
resource_group_name = azurerm_resource_group.rg-vineet-01.name
  location = azurerm_resource_group.rg-vineet-01.location
size = "Standard_B2s"
admin_username = "azuser"
disable_password_authentication = "false"
admin_password = "${random_string.vm_pwd.result}"
network_interface_ids = [
azurerm_network_interface.nic.id,
]


os_disk {
caching = "ReadWrite"
storage_account_type = "Standard_LRS"
}


source_image_reference {
publisher = "Canonical"
offer = "UbuntuServer"
sku = "16.04-LTS"
version = "latest"
}
}

resource "random_string" "vm_pwd" {
length = 8
min_lower = 2
min_numeric = 2
min_special = 1
min_upper = 1
}

output "vmpasswd" {
value = "${random_string.vm_pwd.result}"
}


data "azurerm_client_config" "mytenant" {}

resource "azurerm_key_vault" "vmkeyvault" {
name = "vmkv-linux"
resource_group_name = azurerm_resource_group.rg-vineet-01.name
  location = azurerm_resource_group.rg-vineet-01.location
enabled_for_disk_encryption = true
tenant_id = data.azurerm_client_config.mytenant.tenant_id
soft_delete_retention_days = 7
purge_protection_enabled = false
sku_name = "standard"
access_policy {
tenant_id = data.azurerm_client_config.mytenant.tenant_id
object_id = data.azurerm_client_config.mytenant.object_id
key_permissions = [
"Get",
"List",
"delete",
"purge",
"recover",
]
secret_permissions = [
"Get",
"Set",
"List",
"delete",
"purge",
"recover",
]
storage_permissions = [
"Get",
"List",
"delete",
"purge",
"recover",
]
certificate_permissions = [
"Get",
"List",
"delete",
"purge",
"recover",
]
}
}
resource "azurerm_key_vault_secret" "linvm_pwd" {
name = "secret-vmpwd"
value = "${random_string.vm_pwd.result}"
key_vault_id = azurerm_key_vault.vmkeyvault.id
}

terraform {
	required_providers {
		azurerm = {
			source = "hashicorp/azurerm"
			version = "2.76.0"
		}
	}
}

provider "azurerm" {
  features {
      key_vault {
purge_soft_delete_on_destroy = true
}
  }
  subscription_id = "12917876-07d8-437d-b861-0927df9abe3a"
  tenant_id = "cf626e3e-0aa9-4d45-bb03-cc1e22523cf8"
  client_id = "820b0a1c-8c02-43e4-8284-3051ac2ae305"
  client_secret = "E1s7Q~jqEROethPEqP4ySY8wvLkvswfIcGOWk"
}

terraform  {
  backend "azurerm" {
    resource_group_name  = "cloud-shell-storage-centralindia"
    storage_account_name = "csg10032001e138ab19"
    container_name       = "terraform"
    key                  = "infra.tfstate"
    access_key           = "5j7xuk1VE+hXNxuUScFFFotMcDee+KIC+S4bvwO5lL8ecWNY+qTvL7OYFcwkJLyPazrPln09/3OQxE1BY+wySw=="
    
  }
}
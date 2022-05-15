#input variables 
#business unit name 
variable "business_unit" {
    type = string
    default = "it"
}

#enivronment variable 
variable "enivornment" {
    type = string
    default = "prod"
}

#rg name 
variable "rg-name"{
    type = string
    default = "myrg"
}

#location 
variable "location"{
    type = string
    default = "east us"
}

#vnet name
variable "vnet-name" {
    type = string
    default = "myvnet"
}

#ip 
variable "vnetip" {
    type = list 
    default = ["10.10.0.0/16"]
  
}

#subnet name 
variable "subnet-name"{
    type = string
    default = "mysubnet"
}

#subnet IP
variable "subnetip" {
    type = list
    default = ["10.10.0.0/24"]
}

#allocation method
variable "pip-allocation_method"{
    type = string
    default = "Static"
}

#vm name 
variable "vm-name"{
    type = string
    default = "bvkvm"
}
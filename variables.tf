variable "prefix" {
  description = "org prefix, 2-4 chars lowercase alphanumeric"
  type = string
  validation {
    condition = can(regex("^[a-z0-9]{2,4}$", var.prefix))
    error_message = "prefix needs to be 2-4 lowercase alphanumeric"
  }
}

variable "environment" {
  description = "env: dev, tst, stg, prd, uat"
  type = string
  validation {
    condition = contains(["dev", "tst", "stg", "prd", "uat"], var.environment)
    error_message = "env must be dev/tst/stg/prd/uat"
  }
}

variable "location" {
  description = "azure region"
  type = string
}

variable "resource_type_name" {
  description = "storage_account, private_endpoint, or virtual_machine"
  type = string
  default = "storage_account"
  validation {
    condition = contains(["storage_account", "private_endpoint", "virtual_machine"], var.resource_type_name)
    error_message = "resource type should be storage_account/private_endpoint/virtual_machine"
  }
}

variable "resource_type" {
  description = "resource code (st/pe/vm), optional"
  type = string
  default = ""
}

variable "resource_group_name" {
  description = "rg name - needed for PE and VM checks"
  type = string
  default = ""
}

variable "instance_number" {
  description = "instance num, default 1"
  type = number
  default = 1
  validation {
    condition = var.instance_number >= 1 && var.instance_number <= 999
    error_message = "instance should be 1-999"
  }
}

variable "base_name" {
  description = "custom name if you want to override"
  type = string
  default = ""
}

variable "check_azure_existence" {
  description = "check azure for name availability"
  type = bool
  default = true
}

variable "use_hyphens" {
  description = "use hyphens or not, auto-detected if null"
  type = bool
  default = null
}

variable "subscription_id" {
  description = "azure sub id for checks"
  type = string
  default = ""
}


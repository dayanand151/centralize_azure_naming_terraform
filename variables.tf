variable "prefix" {
  description = "Org or team identifier, 2-4 lowercase alphanumeric chars"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]{2,4}$", var.prefix))
    error_message = "Prefix must be 2-4 lowercase alphanumeric characters."
  }
}

variable "environment" {
  description = "Environment: dev, tst, stg, prd, or uat"
  type        = string
  validation {
    condition     = contains(["dev", "tst", "stg", "prd", "uat"], var.environment)
    error_message = "Environment must be one of: dev, tst, stg, prd, uat."
  }
}

variable "location" {
  description = "Azure region like eastus or westeurope"
  type        = string
}

variable "resource_type_name" {
  description = "Type of resource: storage_account, private_endpoint, or virtual_machine"
  type        = string
  default     = "storage_account"
  validation {
    condition     = contains(["storage_account", "private_endpoint", "virtual_machine"], var.resource_type_name)
    error_message = "Resource type must be one of: storage_account, private_endpoint, virtual_machine."
  }
}

variable "resource_type" {
  description = "Resource code like st, pe, vm. Auto-set if not provided"
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "Resource group name. Required for PE and VM conflict checks"
  type        = string
  default     = ""
}

variable "instance_number" {
  description = "Instance number for conflict handling, starts at 1"
  type        = number
  default     = 1
  validation {
    condition     = var.instance_number >= 1 && var.instance_number <= 999
    error_message = "Instance number must be between 1 and 999."
  }
}

variable "base_name" {
  description = "Custom base name instead of auto-generated"
  type        = string
  default     = ""
}

variable "check_azure_existence" {
  description = "Check if name exists in Azure before returning"
  type        = bool
  default     = true
}

variable "use_hyphens" {
  description = "Use hyphens in name. Auto-set based on resource type if not specified"
  type        = bool
  default     = null
}

variable "subscription_id" {
  description = "Azure subscription ID for name availability checks"
  type        = string
  default     = ""
}


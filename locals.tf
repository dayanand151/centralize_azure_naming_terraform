locals {
  location_mapping = {
    "eastus"              = "eus"
    "eastus2"             = "eus2"
    "westus"              = "wus"
    "westus2"             = "wus2"
    "centralus"           = "cus"
    "northcentralus"      = "ncus"
    "southcentralus"      = "scus"
    "westcentralus"       = "wcus"
    "canadacentral"       = "cac"
    "canadaeast"          = "cae"
    "brazilsouth"         = "brs"
    "northeurope"         = "neu"
    "westeurope"          = "weu"
    "uksouth"             = "uks"
    "ukwest"              = "ukw"
    "francecentral"       = "frc"
    "francesouth"         = "frs"
    "germanywestcentral"  = "dewc"
    "germanynorth"        = "den"
    "switzerlandnorth"    = "chn"
    "switzerlandwest"     = "chw"
    "norwayeast"          = "noe"
    "norwaywest"          = "now"
    "swedencentral"       = "sec"
    "uaenorth"            = "aen"
    "uaecentral"          = "aec"
    "southafricanorth"    = "zan"
    "southafricawest"     = "zaw"
    "japaneast"           = "jpe"
    "japanwest"           = "jpw"
    "koreacentral"        = "krc"
    "koreasouth"          = "krs"
    "southeastasia"       = "sea"
    "eastasia"            = "eas"
    "australiaeast"       = "aue"
    "australiasoutheast"  = "ause"
    "australiacentral"    = "auc"
    "australiacentral2"   = "auc2"
    "indiawest"           = "inw"
    "indiasouth"          = "ins"
    "indiacentral"        = "inc"
    "chinanorth"          = "cnn"
    "chinanorth2"         = "cnn2"
    "chinaeast"           = "cne"
    "chinaeast2"          = "cne2"
  }

  location_short = lookup(local.location_mapping, lower(var.location), substr(replace(lower(var.location), "-", ""), 0, 3))

  resource_type_code = var.resource_type != "" ? var.resource_type : (
    var.resource_type_name == "storage_account" ? "st" : (
      var.resource_type_name == "private_endpoint" ? "pe" : "vm"
    )
  )

  use_hyphens_in_name = var.use_hyphens != null ? var.use_hyphens : (
    var.resource_type_name == "storage_account" ? false : true
  )

  max_length = var.resource_type_name == "storage_account" ? 24 : (
    var.resource_type_name == "private_endpoint" ? 80 : 64
  )
  min_length = 1

  base_name_generated = var.base_name != "" ? var.base_name : (
    local.use_hyphens_in_name ? 
      "${var.prefix}-${var.environment}-${local.location_short}-${local.resource_type_code}" :
      "${var.prefix}${var.environment}${local.location_short}${local.resource_type_code}"
  )

  instance_formatted = format("%03d", var.instance_number)

  generated_name = local.use_hyphens_in_name ? 
    "${local.base_name_generated}-${local.instance_formatted}" :
    "${local.base_name_generated}${local.instance_formatted}"

  name_length_valid = length(local.generated_name) >= local.min_length && length(local.generated_name) <= local.max_length

  name_format_valid = var.resource_type_name == "storage_account" ? 
    can(regex("^[a-z0-9]+$", local.generated_name)) : (
      var.resource_type_name == "private_endpoint" ?
        can(regex("^[a-z0-9][a-z0-9\\-_.]*[a-z0-9]$|^[a-z0-9]$", local.generated_name)) :
        can(regex("^[a-z0-9][a-z0-9\\-.]*[a-z0-9]$|^[a-z0-9]$", local.generated_name))
    )
}


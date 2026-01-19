# check storage account name availability
data "external" "storage_account_name_availability" {
  count = var.check_azure_existence && var.subscription_id != "" && var.resource_type_name == "storage_account" ? 1 : 0
  program = ["bash", "-c", <<-EOT
    az account set --subscription "${var.subscription_id}" >/dev/null 2>&1; az storage account check-name --name "${local.generated_name}" --query "{nameAvailable:nameAvailable,reason:reason}" --output json 2>/dev/null | jq -r '{nameAvailable: (.nameAvailable | tostring), reason: (.reason // "null" | tostring)}' || echo '{"nameAvailable":"true","reason":"check_failed"}'
  EOT
  ]
}

# check PE name in resource group
data "external" "private_endpoint_name_availability" {
  count = var.check_azure_existence && var.subscription_id != "" && var.resource_type_name == "private_endpoint" && var.resource_group_name != "" ? 1 : 0
  program = ["bash", "-c", <<-EOT
    az account set --subscription "${var.subscription_id}" >/dev/null 2>&1; az network private-endpoint list --resource-group "${var.resource_group_name}" --query "[?name=='${local.generated_name}']" --output json 2>/dev/null | jq -r 'if length > 0 then "{\"nameAvailable\":\"false\",\"reason\":\"AlreadyExists\"}" else "{\"nameAvailable\":\"true\",\"reason\":\"null\"}" end' || echo '{"nameAvailable":"true","reason":"check_failed"}'
  EOT
  ]
}

# check VM name in resource group
data "external" "virtual_machine_name_availability" {
  count = var.check_azure_existence && var.subscription_id != "" && var.resource_type_name == "virtual_machine" && var.resource_group_name != "" ? 1 : 0
  program = ["bash", "-c", <<-EOT
    az account set --subscription "${var.subscription_id}" >/dev/null 2>&1; az vm list --resource-group "${var.resource_group_name}" --query "[?name=='${local.generated_name}']" --output json 2>/dev/null | jq -r 'if length > 0 then "{\"nameAvailable\":\"false\",\"reason\":\"AlreadyExists\"}" else "{\"nameAvailable\":\"true\",\"reason\":\"null\"}" end' || echo '{"nameAvailable":"true","reason":"check_failed"}'
  EOT
  ]
}

locals {
  # check if name is available
  name_available = var.check_azure_existence && var.subscription_id != "" ? (
    var.resource_type_name == "storage_account" ? (
      try(data.external.storage_account_name_availability[0].result.nameAvailable == "true", true)
    ) : (
      var.resource_type_name == "private_endpoint" ? (
        var.resource_group_name != "" ? (
          try(data.external.private_endpoint_name_availability[0].result.nameAvailable == "true", true)
        ) : true
      ) : (
        var.resource_type_name == "virtual_machine" ? (
          var.resource_group_name != "" ? (
            try(data.external.virtual_machine_name_availability[0].result.nameAvailable == "true", true)
          ) : true
        ) : true
      )
    )
  ) : true

  validation_passed = local.name_length_valid && local.name_format_valid && local.name_available
  conflict_detected = var.check_azure_existence && var.subscription_id != "" && !local.name_available
}


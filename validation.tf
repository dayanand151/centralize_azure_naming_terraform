data "external" "storage_account_name_availability" {
  count   = var.check_azure_existence && var.subscription_id != "" && var.resource_type_name == "storage_account" ? 1 : 0
  program = ["bash", "-c", <<-EOT
    az storage account check-name --name "${local.generated_name}" --query "{nameAvailable:nameAvailable,reason:reason}" --output json 2>/dev/null || echo '{"nameAvailable":true,"reason":"check_failed"}'
  EOT
  ]
}

data "external" "private_endpoint_name_availability" {
  count   = var.check_azure_existence && var.subscription_id != "" && var.resource_type_name == "private_endpoint" && var.resource_group_name != "" ? 1 : 0
  program = ["bash", "-c", <<-EOT
    az network private-endpoint list --resource-group "${var.resource_group_name}" --query "[?name=='${local.generated_name}']" --output json 2>/dev/null | jq -r 'if length > 0 then "{\"nameAvailable\":false,\"reason\":\"AlreadyExists\"}" else "{\"nameAvailable\":true,\"reason\":null}" end' || echo '{"nameAvailable":true,"reason":"check_failed"}'
  EOT
  ]
}

data "external" "virtual_machine_name_availability" {
  count   = var.check_azure_existence && var.subscription_id != "" && var.resource_type_name == "virtual_machine" && var.resource_group_name != "" ? 1 : 0
  program = ["bash", "-c", <<-EOT
    az vm list --resource-group "${var.resource_group_name}" --query "[?name=='${local.generated_name}']" --output json 2>/dev/null | jq -r 'if length > 0 then "{\"nameAvailable\":false,\"reason\":\"AlreadyExists\"}" else "{\"nameAvailable\":true,\"reason\":null}" end' || echo '{"nameAvailable":true,"reason":"check_failed"}'
  EOT
  ]
}

locals {
  name_available = var.check_azure_existence && var.subscription_id != "" ? (
    var.resource_type_name == "storage_account" ? (
      try(jsondecode(data.external.storage_account_name_availability[0].result.nameAvailable), true)
    ) : (
      var.resource_type_name == "private_endpoint" ? (
        var.resource_group_name != "" ? (
          try(jsondecode(data.external.private_endpoint_name_availability[0].result.nameAvailable), true)
        ) : true
      ) : (
        var.resource_type_name == "virtual_machine" ? (
          var.resource_group_name != "" ? (
            try(jsondecode(data.external.virtual_machine_name_availability[0].result.nameAvailable), true)
          ) : true
        ) : true
      )
    )
  ) : true

  validation_passed = local.name_length_valid && local.name_format_valid && local.name_available
  conflict_detected = var.check_azure_existence && var.subscription_id != "" && !local.name_available
}


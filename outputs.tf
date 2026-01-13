output "generated_name" {
  description = "Generated resource name"
  value       = local.generated_name
}

output "final_name" {
  description = "Final name after conflict resolution"
  value       = local.resolved_name
}

output "validation_passed" {
  description = "Name validation status"
  value       = local.validation_passed
}

output "name_length_valid" {
  description = "Name length validation"
  value       = local.name_length_valid
}

output "name_format_valid" {
  description = "Name format validation"
  value       = local.name_format_valid
}

output "name_available" {
  description = "Name availability in Azure"
  value       = local.name_available
}

output "conflict_detected" {
  description = "Whether a conflict was detected"
  value       = local.conflict_detected
}

output "alternative_name" {
  description = "Alternative name if conflict exists"
  value       = local.conflict_detected ? local.alternative_name : null
}

output "next_instance_number" {
  description = "Next instance number for conflict resolution"
  value       = local.next_instance_number
}

output "validation_details" {
  description = "Complete validation details"
  value = {
    name              = local.generated_name
    resource_type_name = var.resource_type_name
    length            = length(local.generated_name)
    length_valid      = local.name_length_valid
    format_valid      = local.name_format_valid
    name_available    = local.name_available
    conflict_detected = local.conflict_detected
    components = {
      prefix         = var.prefix
      environment    = var.environment
      location       = local.location_short
      resource_type  = local.resource_type_code
      instance       = var.instance_number
    }
    constraints = {
      min_length = local.min_length
      max_length = local.max_length
      hyphens_allowed = local.use_hyphens_in_name
    }
  }
}


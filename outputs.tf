output "generated_name" {
  value = local.generated_name
}

output "final_name" {
  value = local.resolved_name
}

output "validation_passed" {
  value = local.validation_passed
}

output "name_length_valid" {
  value = local.name_length_valid
}

output "name_format_valid" {
  value = local.name_format_valid
}

output "name_available" {
  value = local.name_available
}

output "conflict_detected" {
  value = local.conflict_detected
}

output "alternative_name" {
  value = local.conflict_detected ? local.alternative_name : null
}

output "next_instance_number" {
  value = local.next_instance_number
}

output "validation_details" {
  value = {
    name = local.generated_name
    resource_type_name = var.resource_type_name
    length = length(local.generated_name)
    length_valid = local.name_length_valid
    format_valid = local.name_format_valid
    name_available = local.name_available
    conflict_detected = local.conflict_detected
    components = {
      prefix = var.prefix
      environment = var.environment
      location = local.location_short
      resource_type = local.resource_type_code
      instance = var.instance_number
    }
    constraints = {
      min_length = local.min_length
      max_length = local.max_length
      hyphens_allowed = local.use_hyphens_in_name
    }
  }
}


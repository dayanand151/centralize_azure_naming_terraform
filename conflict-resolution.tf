locals {
  next_instance_number = var.instance_number + 1
  alternative_name = local.use_hyphens_in_name ? 
    "${local.base_name_generated}-${format("%03d", local.next_instance_number)}" :
    "${local.base_name_generated}${format("%03d", local.next_instance_number)}"
  resolved_name = local.conflict_detected ? local.alternative_name : local.generated_name
}


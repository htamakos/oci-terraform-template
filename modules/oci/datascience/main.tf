resource "oci_datascience_project" "default" {
  for_each = var.oci_datascience_project_config != null ? var.oci_datascience_project_config : {}

  compartment_id = each.value.compartment_name != null ? local.compartment_ids[each.value.compartment_name] : var.oci_compartment_id

  description  = each.value.description
  display_name = "${var.name_prefix}_${each.value.display_name}"

  lifecycle {
    ignore_changes = [defined_tags]
  }
}

resource "oci_datascience_notebook_session" "default" {
  for_each = var.oci_datascience_notebook_session_config != null ? var.oci_datascience_notebook_session_config : {}

  display_name   = "${var.name_prefix}_${each.value.display_name}"
  compartment_id = oci_datascience_project.default[each.value.project_key].compartment_id

  project_id = oci_datascience_project.default[each.value.project_key].id
  notebook_session_configuration_details {
    shape                     = each.value.shape
    subnet_id                 = var.oci_subnet_ids[each.value.subnet_key]
    block_storage_size_in_gbs = each.value.block_storage_size_in_gbs

    dynamic "notebook_session_shape_config_details" {
      for_each = each.value.notebook_session_shape_config_details != null ? [each.value.notebook_session_shape_config_details] : []

      content {
        memory_in_gbs = notebook_session_shape_config_details.value.memory_in_gbs
        ocpus         = notebook_session_shape_config_details.value.ocpus
      }
    }
  }
}

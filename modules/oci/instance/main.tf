resource "oci_core_instance" "default" {
  for_each = var.oci_instance_config != null ? var.oci_instance_config : {}

  compartment_id      = var.oci_compartment_id
  availability_domain = each.value.oci_availability_domain
  #fault_domain        = each.value.oci_fault_domain

  display_name = "${var.name_prefix}_${each.value.display_name}"
  shape        = each.value.shape

  dynamic "shape_config" {
    for_each = each.value.shape_config != null ? [each.value.shape_config] : []

    content {
      memory_in_gbs = shape_config.value.instance_shape_config_memory_in_gbs
      ocpus         = shape_config.value.instance_shape_config_ocpus
    }

  }

  create_vnic_details {
    assign_public_ip = each.value.assign_public_ip
    private_ip       = each.value.private_ip
    subnet_id        = var.oci_subnet_ids[each.value.subnet_key]
    hostname_label   = each.value.hoshostname_label
  }

  source_details {
    source_id   = each.value.source_id
    source_type = "image"

    boot_volume_size_in_gbs = each.value.boot_volume_size_in_gbs
  }

  preserve_boot_volume = each.value.preserve_boot_volume

  metadata = {
    ssh_authorized_keys = file(each.value.metadata.ssh_authorized_keys)
    user_data           = each.value.metadata.user_data != null ? each.value.metadata.user_data : ""
  }
}

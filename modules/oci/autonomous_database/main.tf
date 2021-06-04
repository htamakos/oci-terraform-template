resource "oci_database_autonomous_database" "default" {
  for_each = var.oci_autonomous_database_config

  compartment_id = var.oci_compartment_id

  admin_password = each.value.admin_password

  cpu_core_count           = each.value.cpu_core_count
  data_storage_size_in_tbs = each.value.data_storage_size_in_tbs

  db_name     = each.value.db_name
  db_version  = each.value.db_version
  db_workload = each.value.db_workload

  display_name = "${var.name_prefix}_${each.value.display_name}"

  is_auto_scaling_enabled                        = each.value.is_auto_scaling_enabled
  is_dedicated                                   = each.value.is_dedicated
  is_free_tier                                   = each.value.is_free_tier
  is_preview_version_with_service_terms_accepted = each.value.is_preview_version_with_service_terms_accepted

  license_model = each.value.license_model

  private_endpoint_label = each.value.private_endpoint_label
  subnet_id              = var.oci_subnet_ids != null && each.value.subnet_key != null ? var.oci_subnet_ids[each.value.subnet_key] : null

  whitelisted_ips = each.value.whitelisted_ips
}

resource "random_string" "adb_wallet_password" {
  length  = 16
  special = true
}

resource "oci_database_autonomous_database_wallet" "default" {
  for_each = var.oci_autonomous_database_config != null ? var.oci_autonomous_database_config : {}

  autonomous_database_id = oci_database_autonomous_database.default[each.key].id

  password               = random_string.adb_wallet_password.result
  base64_encode_content  = "true"
}

resource "local_file" "autonomous_database_wallet_file" {
  for_each = var.oci_autonomous_database_config != null ? var.oci_autonomous_database_config : {}

  content_base64 = oci_database_autonomous_database_wallet.default[each.key].content
  filename       = "autonomous_database_wallet_${each.key}.zip"
}

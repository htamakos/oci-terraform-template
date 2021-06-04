resource "oci_database_db_system" "default" {
  for_each = var.oci_database_config != null ? var.oci_database_config : {}

  availability_domain = each.value.oci_availability_domain
  fault_domains       = each.value.oci_fault_domains

  compartment_id   = var.oci_compartment_id
  database_edition = each.value.database_edition
  display_name     = "${var.name_prefix}_${each.value.display_name}"

  db_home {
    database {
      admin_password = each.value.admin_password
      db_name        = each.value.db_name
      character_set  = each.value.character_set
      ncharacter_set = each.value.ncharacter_set
      db_workload    = each.value.db_workload
      pdb_name       = each.value.pdb_name

      db_backup_config {
        auto_backup_enabled = each.value.auto_backup_enabled
      }

      defined_tags = each.value.defined_tags
    }


    db_version   = each.value.db_version
    display_name = each.value.display_name
  }

  db_system_options {
    storage_management = each.value.storage_management
  }


  shape     = each.value.shape
  subnet_id = var.oci_subnet_ids[each.value.subnet_key]
  ssh_public_keys = [
    for key in each.value.ssh_public_keys :
    file(key)
  ]

  hostname                = each.value.hostname
  data_storage_percentage = each.value.data_storage_percentage
  data_storage_size_in_gb = each.value.data_storage_size_in_gb
  license_model           = each.value.license_model
  node_count              = each.value.node_count
  private_ip              = each.value.private_ip
  time_zone               = each.value.time_zone

  defined_tags = each.value.defined_tags

  lifecycle {
    ignore_changes = [ssh_public_keys, defined_tags, db_home[0].database[0].defined_tags]
  }
}


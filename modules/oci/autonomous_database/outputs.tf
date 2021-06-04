output "oci_autonomous_databases" {
  value = {
    for k, db in oci_database_autonomous_database.default :
    k => {
      cpu_core_count           = db.cpu_core_count,
      data_storage_size_in_tbs = db.data_storage_size_in_tbs,
      db_name                  = db.db_name,
      db_version               = db.db_version,
      state                    = db.state,
      whitelisted_ips          = db.whitelisted_ips,
      service_console_url      = db.service_console_url,
      connection_urls          = db.connection_urls,
      is_free_tier             = db.is_free_tier,
    }
  }
}

output "autonomous_database_wallet_password" {
  value = random_string.adb_wallet_password.result
}


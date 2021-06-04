output "oci_databases" {
  value = {
    for k, db in oci_database_db_system.default :
    k => {
      private_ip          = db.private_ip,
      availability_domain = db.availability_domain,
      cpu_core_count      = db.cpu_core_count,
      database_edition    = db.database_edition,
      db_name             = db.db_home[0].database[0].db_name
      db_unique_name      = db.db_home[0].database[0].db_unique_name
      pdb_name            = db.db_home[0].database[0].pdb_name
      db_version          = db.db_home[0].db_version
      listener_port       = db.listener_port
      node_state          = db.state
    }
  }
}

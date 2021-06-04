variable "name_prefix" {
  type = string
}

variable "oci_compartment_id" {
  type = string
}

variable "oci_subnet_ids" {
  type = map(string)
}

variable "oci_database_config" {
  type = map(object({
    oci_availability_domain = string
    oci_fault_domains       = list(string)

    # Example: ENTERPRISE_EDITION_HIGH_PERFORMANCE
    database_edition = string
    display_name     = string
    admin_password   = string

    db_name = string

    # Example: AL32UTF8
    character_set = string

    # AL16UTF16 or UTF8
    ncharacter_set = string

    # OLTP or DSS
    db_workload         = string
    pdb_name            = string
    auto_backup_enabled = bool

    db_version = string

    # ASM or LVM
    storage_management = string

    shape                   = string
    subnet_key              = string
    data_storage_percentage = number
    data_storage_size_in_gb = number

    # LICENSE_INCLUDED or BRING_YOUR_OWN_LICENSE
    license_model = string

    node_count      = number
    private_ip      = string
    hostname        = string
    ssh_public_keys = set(string)

    # Example: Asia/Tokyo
    time_zone = string

    defined_tags = map(string)
  }))
}

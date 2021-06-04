variable "name_prefix" {
  type = string
}

variable "oci_compartment_id" {
  type = string
}

variable "oci_subnet_ids" {
  type = map(string)
}

variable "oci_autonomous_database_config" {
  type = map(object({
    display_name   = string
    admin_password = string

    cpu_core_count           = number
    data_storage_size_in_tbs = number

    # OLTP or DSS
    db_name     = string
    db_workload = string
    db_version  = string

    is_auto_scaling_enabled                        = bool
    is_dedicated                                   = bool
    is_free_tier                                   = bool
    is_preview_version_with_service_terms_accepted = bool

    # LICENSE_INCLUDED or BRING_YOUR_OWN_LICENSE
    license_model = string

    private_endpoint_label = string
    subnet_key             = string
    whitelisted_ips        = set(string)
  }))
}

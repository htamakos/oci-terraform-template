variable "oci_tenancy_ocid" {
  type = string
}

variable "oci_user_ocid" {
  type = string
}

variable "oci_fingerprint" {
  type = string
}

variable "oci_private_key_path" {
  type = string
}

variable "oci_region" {
  type = string
}

variable "oci_compartment_id" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "enable_output_oci_info" {
  type    = bool
  default = false
}

# Network
# VCNs
variable "oci_vcn_config" {
  type = map(object({
    display_name     = string,
    cidr_block       = string,
    dns_label        = string,
    compartment_name = string,
  }))
}

## Subnets
variable "oci_subnet_config" {
  type = map(object({
    display_name               = string
    cidr_block                 = string
    dns_label                  = string
    vcn_key                    = string
    prohibit_public_ip_on_vnic = bool

    oci_security_list_config = object({
      vcn_key      = string
      defined_tags = set(string)
      egress_security_rules = map(object({
        destination = string,
        protocol    = string,
        stateless   = string,
        port        = number,
      })),

      ingress_security_rules = map(object({
        source    = string,
        protocol  = string,
        stateless = bool,
        port      = number,
      }))
    })
  }))
}

# Instance
variable "oci_instance_config" {
  type = map(object({
    display_name = string
    subnet_key   = string
    shape        = string
    shape_config = object({
      instance_shape_config_ocpus         = number
      instance_shape_config_memory_in_gbs = number
    })
    oci_availability_domain = string
    oci_fault_domain        = string
    assign_public_ip        = bool
    private_ip              = string
    hoshostname_label       = string
    source_id               = string
    boot_volume_size_in_gbs = number
    metadata = object({
      ssh_authorized_keys = string
      user_data           = string
    })

    preserve_boot_volume = bool
  }))
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

# Autonoumous Databases
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

    subnet_key             = string
    private_endpoint_label = string
    whitelisted_ips        = set(string)
  }))
}

# DataScience
variable "oci_datascience_project_config" {
  type = map(object({
    compartment_name = string
    description      = string
    display_name     = string
  }))
}

variable "oci_datascience_notebook_session_config" {
  type = map(object({
    display_name              = string
    shape                     = string
    subnet_key                = string
    project_key               = string
    block_storage_size_in_gbs = number
    notebook_session_shape_config_details = object({
      memory_in_gbs = number
      ocpus         = number
    })
  }))
}

# IAM
variable "oci_user_config" {
  type = map(object({
    name        = string,
    description = string,
    email       = string,
  }))
}

variable "oci_group_config" {
  type = map(object({
    name        = string,
    description = string,
  }))
}

variable "oci_user_group_config" {
  type = map(object({
    group_key = string,
    user_key  = string,
  }))
}

variable "oci_dynamic_group_config" {
  type = map(object({
    description   = string,
    matching_rule = string,
    name          = string,
  }))
}

variable "oci_policy_config" {
  type = map(object({
    description = string,
    statements  = list(string),
    name        = string,
  }))
}

variable "name_prefix" {
  type = string
}
variable "oci_compartment_id" {
  type = string
}

variable "oci_subnet_ids" {
  type = map(string)
}

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

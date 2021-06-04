variable "name_prefix" {
  type = string
}

variable "oci_tenancy_ocid" {
  type = string
}

variable "oci_compartment_id" {
  type = string
}

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

variable "oci_subnet_ids" {
  type = map(string)
}

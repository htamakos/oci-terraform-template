variable "name_prefix" {
  type = string
}

variable "oci_tenancy_ocid" {
  type = string
}

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

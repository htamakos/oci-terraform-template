# User
resource "oci_identity_user" "default" {
  for_each = var.oci_user_config != null ? var.oci_user_config : {}

  compartment_id = var.oci_tenancy_ocid
  name           = each.value.name
  description    = each.value.description
  email          = each.value.email
}

# Group
resource "oci_identity_group" "default" {
  for_each = var.oci_group_config != null ? var.oci_group_config : {}

  compartment_id = var.oci_tenancy_ocid
  name           = each.value.name
  description    = each.value.description
}

# User-Group
resource "oci_identity_user_group_membership" "default" {
  for_each = var.oci_user_group_config != null ? var.oci_user_group_config : {}

  group_id = oci_identity_group.default[each.value.group_key].id
  user_id  = oci_identity_user.default[each.value.user_key].id
}

# Dynamic Group
resource "oci_identity_dynamic_group" "default" {
  for_each = var.oci_dynamic_group_config != null ? var.oci_dynamic_group_config : {}

  compartment_id = var.oci_tenancy_ocid
  description    = each.value.description
  matching_rule  = each.value.matching_rule
  name           = each.value.name

}

# Policy
resource "oci_identity_policy" "default" {
  for_each = var.oci_policy_config != null ? var.oci_policy_config : {}

  compartment_id = var.oci_tenancy_ocid
  description    = each.value.description
  statements     = each.value.statements
  name           = each.value.name
}

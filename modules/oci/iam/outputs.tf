output "oci_users" {
  value = {
    for k, v in oci_identity_user.default :
    k => v.id
  }
}

output "oci_groups" {
  value = {
    for k, v in oci_identity_group.default :
    k => v.id
  }
}

output "oci_dynamic_groups" {
  value = {
    for k, v in oci_identity_dynamic_group.default :
    k => v.id
  }
}

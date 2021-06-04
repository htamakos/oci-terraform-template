output "oci_vcn_ids" {
  value = {
    for key, vcn in oci_core_vcn.default :
    key => vcn.id
  }
}

output "oci_subnet_ids" {
  value = {
    for key, subnet in oci_core_subnet.default :
    key => subnet.id
  }
}

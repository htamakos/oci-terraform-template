data "oci_identity_compartments" "default" {
  compartment_id = var.oci_tenancy_ocid
}

locals {
  compartment_ids = {
    for v in data.oci_identity_compartments.default.compartments :
    v.name => v.id
  }
}

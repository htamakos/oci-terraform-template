data "oci_identity_availability_domains" "default" {
  compartment_id = var.oci_compartment_id
}

data "oci_core_images" "default" {
  compartment_id = var.oci_compartment_id
  shape          = "VM.Standard.A1.Flex"
}

data "oci_core_shapes" "default" {
  compartment_id = var.oci_compartment_id
}

data "oci_identity_fault_domains" "default" {
  for_each            = var.oci_instance_config
  compartment_id      = var.oci_compartment_id
  availability_domain = each.value.oci_availability_domain
}

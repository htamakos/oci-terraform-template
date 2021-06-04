output "oci_vcn_ids" {
  value = module.oci-network.oci_vcn_ids
}

output "oci_subnet_ids" {
  value = module.oci-network.oci_subnet_ids
}

output "oci_availability_domains" {
  value = var.enable_output_oci_info ? module.oci-instance.oci_availability_domains : null
}

output "oci_images" {
  value = var.enable_output_oci_info ? module.oci-instance.oci_images : null
}

output "oci_shapes" {
  value = var.enable_output_oci_info ? module.oci-instance.oci_shapes : null
}

output "oci_fault_domains" {
  value = var.enable_output_oci_info ? module.oci-instance.oci_fault_domains : null
}

output "oci_instances" {
  value = module.oci-instance.oci_instances
}

output "oci_databases" {
  value = module.oci-database.oci_databases
}

output "oci_autonomous_databases" {
  value = module.oci-autonoumous-database.oci_autonomous_databases
}

output "oci_datascience_notebook_session_urls" {
    value = module.oci-datascience.oci_datascience_notebook_session_urls
}

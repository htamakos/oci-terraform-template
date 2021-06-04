output "oci_availability_domains" {
  value = [
    for v in data.oci_identity_availability_domains.default.availability_domains :
    v.name
  ]
}

output "oci_images" {
  value = [
    for v in data.oci_core_images.default.images :
    {
      id           = v.id,
      display_name = v.display_name
    }
  ]
}

output "oci_shapes" {
  value = [
    for v in data.oci_core_shapes.default.shapes :
    {
      name                         = v.name,
      ocpus                        = v.ocpus,
      memory_in_gbs                = v.memory_in_gbs,
      networking_bandwidth_in_gbps = v.networking_bandwidth_in_gbps
      processor_description        = v.processor_description
    }
  ]
}

output "oci_instances" {
  value = {
    for k, v in oci_core_instance.default :
    k => {
      id                  = v.id,
      private_ip          = v.private_ip,
      public_ip           = v.public_ip,
      state               = v.state,
      shape               = v.shape,
      availability_domain = v.availability_domain,
    }
  }
}

output "oci_fault_domains" {
  value = data.oci_identity_fault_domains.default
}

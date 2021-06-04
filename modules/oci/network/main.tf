# VCNs
resource "oci_core_vcn" "default" {
  for_each = var.oci_vcn_config

  compartment_id = each.value.compartment_name != null ? local.compartment_ids[each.value.compartment_name] : var.oci_compartment_id
  display_name   = "${var.name_prefix}_vcn_${each.value.display_name}"
  dns_label      = each.value.dns_label

  cidr_block = each.value.cidr_block
}

# Internet Gateway
resource "oci_core_internet_gateway" "default" {
  for_each = var.oci_vcn_config

  compartment_id = oci_core_vcn.default[each.key].compartment_id
  display_name   = "${var.name_prefix}_${var.oci_internet_gateway_shortname}"
  vcn_id         = oci_core_vcn.default[each.key].id
}

# Service Gateway
resource "oci_core_service_gateway" "default" {
  for_each = var.oci_vcn_config

  compartment_id = oci_core_vcn.default[each.key].compartment_id
  display_name   = "${var.name_prefix}_${var.oci_service_gateway_shortname}"
  vcn_id         = oci_core_vcn.default[each.key].id

  services {
    service_id = data.oci_core_services.default.services[0].id
  }
}

# NAT Gateway
resource "oci_core_nat_gateway" "default" {
  for_each = var.oci_vcn_config

  compartment_id = oci_core_vcn.default[each.key].compartment_id

  display_name = "${var.name_prefix}_${var.oci_nat_gateway_shortname}"

  vcn_id = oci_core_vcn.default[each.key].id
}

# Subnets
resource "oci_core_subnet" "default" {
  for_each = var.oci_subnet_config

  compartment_id = oci_core_vcn.default[each.value.vcn_key].compartment_id
  vcn_id         = oci_core_vcn.default[each.value.vcn_key].id
  display_name   = "${var.name_prefix}_subnet_${each.value.display_name}"

  dns_label                  = each.value.dns_label
  cidr_block                 = each.value.cidr_block
  prohibit_public_ip_on_vnic = each.value.prohibit_public_ip_on_vnic

  route_table_id = each.value.prohibit_public_ip_on_vnic ? oci_core_route_table.private-default[each.value.vcn_key].id : oci_core_route_table.public-default[each.value.vcn_key].id

  security_list_ids = [oci_core_security_list.default[each.key].id]
}

# Security Lists
resource "oci_core_security_list" "default" {
  for_each = { for subnet_key, subnet in var.oci_subnet_config :
    subnet_key => {
      oci_security_list_config = subnet.oci_security_list_config,
      vcn_key                  = subnet.vcn_key
      compartment_id           = oci_core_vcn.default[subnet.vcn_key].compartment_id
    }
    if subnet.oci_security_list_config != null
  }

  compartment_id = each.value.compartment_id
  vcn_id         = oci_core_vcn.default[each.value.vcn_key].id
  display_name   = "${var.name_prefix}_seclist_${each.key}"

  dynamic "egress_security_rules" {
    for_each = each.value.oci_security_list_config.egress_security_rules != null ? each.value.oci_security_list_config.egress_security_rules : {}
    content {
      destination = egress_security_rules.value.destination
      protocol    = egress_security_rules.value.protocol
      stateless   = egress_security_rules.value.stateless

      dynamic "tcp_options" {
        for_each = egress_security_rules.value.port != null ? list(egress_security_rules.value.port) : []

        content {
          min = tcp_options.value
          max = tcp_options.value
        }
      }
    }
  }

  dynamic "ingress_security_rules" {
    for_each = each.value.oci_security_list_config.ingress_security_rules != null ? each.value.oci_security_list_config.ingress_security_rules : {}

    content {
      source    = ingress_security_rules.value.source
      protocol  = ingress_security_rules.value.protocol
      stateless = ingress_security_rules.value.stateless

      dynamic "tcp_options" {
        for_each = ingress_security_rules.value.port != null ? list(ingress_security_rules.value.port) : []

        content {
          min = tcp_options.value
          max = tcp_options.value
        }
      }
    }
  }
}

# Route Tables
resource "oci_core_route_table" "public-default" {
  for_each = var.oci_vcn_config

  compartment_id = oci_core_vcn.default[each.key].compartment_id

  vcn_id       = oci_core_vcn.default[each.key].id
  display_name = "${var.name_prefix}_${each.key}_${var.oci_public_shortname}_${var.oci_route_table_shortname}"

  route_rules {
    network_entity_id = oci_core_internet_gateway.default[each.key].id
    cidr_block        = var.oci_public_ip_range
    destination_type  = var.oci_core_route_table_destination_type.CIDR_BLOCK
  }
}

resource "oci_core_route_table" "private-default" {
  for_each = var.oci_vcn_config

  compartment_id = oci_core_vcn.default[each.key].compartment_id
  vcn_id         = oci_core_vcn.default[each.key].id
  display_name   = "${var.name_prefix}_${each.key}_${var.oci_private_shortname}_${var.oci_route_table_shortname}"

  # Service Gateway
  route_rules {
    network_entity_id = oci_core_service_gateway.default[each.key].id
    destination       = data.oci_core_services.default.services[0].cidr_block
    destination_type  = var.oci_core_route_table_destination_type.SERVICE_CIDR_BLOCK
  }

  # NAT Gateway
  route_rules {
    network_entity_id = oci_core_nat_gateway.default[each.key].id
    destination       = var.oci_public_ip_range
    destination_type  = var.oci_core_route_table_destination_type.CIDR_BLOCK
  }
}

# DHCP
resource "oci_core_default_dhcp_options" "default" {
  for_each                   = var.oci_vcn_config
  manage_default_resource_id = oci_core_vcn.default[each.key].default_dhcp_options_id

  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }
}

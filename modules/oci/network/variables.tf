variable "name_prefix" {
  type = string
}

variable "oci_tenancy_ocid" {
  type = string
}

variable "oci_compartment_id" {
  type = string
}

variable "oci_internet_gateway_shortname" {
  type    = string
  default = "ig"
}

variable "oci_nat_gateway_shortname" {
  type    = string
  default = "ng"
}

variable "oci_service_gateway_shortname" {
  type    = string
  default = "sg"
}

variable "oci_route_table_shortname" {
  type    = string
  default = "rt"
}

variable "oci_public_shortname" {
  type    = string
  default = "pub"
}

variable "oci_private_shortname" {
  type    = string
  default = "pri"
}

variable "oci_public_ip_range" {
  type    = string
  default = "0.0.0.0/0"
}

variable "oci_core_route_table_destination_type" {
  type = object({
    CIDR_BLOCK         = string,
    SERVICE_CIDR_BLOCK = string,
  })

  default = {
    CIDR_BLOCK         = "CIDR_BLOCK",
    SERVICE_CIDR_BLOCK = "SERVICE_CIDR_BLOCK"
  }
}

# Network
variable "oci_vcn_config" {
  type = map(object({
    display_name     = string,
    cidr_block       = string,
    dns_label        = string,
    compartment_name = string,
  }))
}

variable "oci_subnet_config" {
  type = map(object({
    display_name               = string
    cidr_block                 = string
    dns_label                  = string
    vcn_key                    = string
    prohibit_public_ip_on_vnic = bool

    oci_security_list_config = object({
      vcn_key      = string
      defined_tags = set(string)
      egress_security_rules = map(object({
        destination = string,
        protocol    = string,
        stateless   = string,
        port        = number,
      })),

      ingress_security_rules = map(object({
        source    = string,
        protocol  = string,
        stateless = bool,
        port      = number,
      }))
    })
  }))
}


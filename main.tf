# Network
## VCNs, Subnets, Internet/NAT/Service Gateway, Route Tables
## Security Lists, DHCP Options
module "oci-network" {
  source = "./modules/oci/network"

  # module-variables
  name_prefix        = var.name_prefix
  oci_tenancy_ocid   = var.oci_tenancy_ocid
  oci_compartment_id = var.oci_compartment_id
  oci_vcn_config     = var.oci_vcn_config
  oci_subnet_config  = var.oci_subnet_config
}

# Instance
module "oci-instance" {
  source = "./modules/oci/instance"

  # module-variables
  name_prefix         = var.name_prefix
  oci_compartment_id  = var.oci_compartment_id
  oci_subnet_ids      = module.oci-network.oci_subnet_ids
  oci_instance_config = var.oci_instance_config
}

# Database
module "oci-database" {
  source = "./modules/oci/database"

  # module-variables
  name_prefix        = var.name_prefix
  oci_compartment_id = var.oci_compartment_id
  oci_subnet_ids     = module.oci-network.oci_subnet_ids
  # oci_database_config = var.oci_database_config
  oci_database_config = null
}

# Autonoumous Database
module "oci-autonoumous-database" {
  source = "./modules/oci/autonomous_database"

  # module-variables
  name_prefix                    = var.name_prefix
  oci_compartment_id             = var.oci_compartment_id
  oci_subnet_ids                 = module.oci-network.oci_subnet_ids
  oci_autonomous_database_config = var.oci_autonomous_database_config
}

# DataScience
module "oci-datascience" {
  source = "./modules/oci/datascience"

  # module-variables
  name_prefix                             = var.name_prefix
  oci_tenancy_ocid                        = var.oci_tenancy_ocid
  oci_compartment_id                      = var.oci_compartment_id
  oci_datascience_project_config          = var.oci_datascience_project_config
  oci_datascience_notebook_session_config = null
  #oci_datascience_notebook_session_config = var.oci_datascience_notebook_session_config
  oci_subnet_ids                          = module.oci-network.oci_subnet_ids
}

# IAM
module "oci-iam" {
  source = "./modules/oci/iam"

  # module-variables
  name_prefix              = var.name_prefix
  oci_tenancy_ocid         = var.oci_tenancy_ocid
  oci_user_config          = var.oci_user_config
  oci_group_config         = var.oci_group_config
  oci_user_group_config    = var.oci_user_group_config
  oci_dynamic_group_config = var.oci_dynamic_group_config
  oci_policy_config        = var.oci_policy_config
}

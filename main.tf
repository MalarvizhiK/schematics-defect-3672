
data "ibm_is_region" "region" {
  name = var.region
}

data "ibm_is_zone" "zone" {
  name   = "us-south-1"
  region = data.ibm_is_region.region.name
}

data "ibm_is_image" "custom_image" {
  name = "ibm-ubuntu-18-04-1-minimal-amd64-2"
}

##############################################################################
# Provider block - Alias initialized tointeract with VNFSVC account
##############################################################################
provider "ibm" {
  generation       = var.generation
  region           = var.region
  ibmcloud_timeout = 300
}

output "ssh_key_private" {
  value = var.private_ssh_key
} 

##############################################################################
# Read/validate Resource Group
##############################################################################
data "ibm_resource_group" "rg" {
  name = var.resource_group
}

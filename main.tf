provider "oci" {
    fingerprint      = var.api_fingerprint
    private_key_path = var.api_private_key_path
    region           = var.region
    tenancy_ocid     = var.tenancy_id
    user_ocid        = var.user_id
}

terraform {
    backend "local" {
      path = "terraform/state/terraform.tfstate"
    }
    required_providers {
      oci = {
        source  = "oracle/oci"
      }
    }
    required_version = ">= 0.13"
}
terraform {
    required_providers {
      oci = {
        source = "oracle/oci"
      }
      cloudinit = {
        source = "hashicorp/cloudinit"
      }
    }
    required_version = ">= 0.13"
}
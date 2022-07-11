variable "compartment_ocid" {
    description = "compartment_ocid that terraform will use to create the resources"
    type        = string
}

variable "subnet_id" {
    description = "subnet_id that terraform will use to create the resources"
    type        = string
}

variable "configuration" {
    description = "The total configuration, List of Objects/Dictionary"
    default     = [{}]
}

variable "instance_state" {
    description = "(Updatable) The target state for the instance. Could be set to RUNNING or STOPPED."
    type        = string
    default     = "RUNNING"

  validation {
      condition     = contains(["RUNNING", "STOPPED"], var.instance_state)
      error_message = "Accepted values are RUNNING or STOPPED."
  }
}

variable "tenancy_id" {
    description = "tenancy id where to create the sources"
    type        = string
}

variable "user_id" {
    description = "id of user that terraform will use to create the resources"
    type        = string
}

variable "api_fingerprint" {
    description = "fingerprint of oci api private key"  
    type        = string  
}

variable "api_private_key_path" {
    description = "private key path in your system"
    type        = string
}

variable "region" {
    description = "region that terraform will use to create the resources"
    type        = string
}

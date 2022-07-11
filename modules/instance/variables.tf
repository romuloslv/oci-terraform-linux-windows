variable "configuration" {
    description = "The total configuration, List of Objects/Dictionary"
    default = [{}]
}

variable "is_winrm_configured_for_ssl" {
    description = "Active winrm"
    type    = string
    default = "true"
}

variable "user_ocid" {
    description = "User default oci"
    type    = string
    default = "opc"
}

variable "ad_number" {
    description = "AD default"
    type    = number
    default = "1"
}

variable "availability_domain" {
    
}

variable "compartment_ocid" {
    
}

variable "instance_state" {
    
}

variable "subnet_id" {
    
}

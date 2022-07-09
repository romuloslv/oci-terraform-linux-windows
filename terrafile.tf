module "instance" {
    source              = "./modules/instance"
    subnet_id           = var.subnet_id
    compartment_ocid    = var.compartment_ocid
    configuration       = var.configuration
    availability_domain = var.availability_domain
    instance_state      = var.instance_state
}
module "instance" {
    source              = "./modules/instance"
    subnet_id           = var.subnet_id
    compartment_ocid    = var.compartment_ocid
    configuration       = var.configuration
    instance_state      = var.instance_state
}

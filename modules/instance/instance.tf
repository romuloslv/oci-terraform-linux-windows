locals {
    serverconfig = [
      for srv in var.configuration : [
        for i in range(1, srv.no_of_instances+1) : {
          display_name    = "${srv.application_name}-${i}"
          shape           = srv.shape
          memory_quantity = srv.memory_quantity
          cpu_quantity    = srv.cpu_quantity
          bot_volume_size = srv.bot_volume_size
          volume_size     = srv.volume_size
          os_system       = srv.os_system
          no_of_instances = srv.no_of_instances
        }
      ]
    ]
}

locals {
    instances = flatten(local.serverconfig)
}

resource "oci_core_instance" "instance" {
    for_each = {for server in local.instances: server.display_name =>  server}

    display_name            = each.value.display_name
    availability_domain     = data.oci_identity_availability_domain.ad.name
    fault_domain            = data.oci_identity_fault_domains.fd.fault_domains[each.value.no_of_instances].name
    compartment_id          = var.compartment_ocid
    shape                   = each.value.shape
    state                   = var.instance_state
    preserve_boot_volume    = false

    shape_config {
      memory_in_gbs = each.value.memory_quantity
      ocpus         = each.value.cpu_quantity
    }

    create_vnic_details {
      subnet_id           = var.subnet_id
      assign_public_ip    = false
    }

    source_details {
      source_id               = each.value.os_system == "Linux" ? data.oci_core_images.oracle_linux.images[0].id : data.oci_core_images.windows_server.images[0].id
      boot_volume_size_in_gbs = each.value.bot_volume_size
      source_type             = "image"
    }

    metadata = {
      ssh_authorized_keys = each.value.os_system == "Linux" ? tls_private_key.key.public_key_openssh : null
      user_data           = each.value.os_system == "Windows" ? base64encode(data.cloudinit_config.config[each.value.display_name].rendered) : null
    }
}

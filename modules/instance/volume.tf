resource "oci_core_volume" "volume" {
    for_each = {for server in local.instances: server.display_name =>  server}

    display_name        = "${each.value.display_name}-OPT"
    availability_domain = var.availability_domain
    compartment_id      = var.compartment_ocid
    size_in_gbs         = each.value.volume_size
}

resource "oci_core_volume_attachment" "volume_attachment" {
    for_each = {for server in local.instances: server.display_name =>  server}

    attachment_type = "iscsi"
    instance_id     = oci_core_instance.instance[each.value.display_name].id
    volume_id       = oci_core_volume.volume[each.value.display_name].id
}
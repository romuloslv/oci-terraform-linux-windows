data "oci_core_images" "oracle_linux" {
    compartment_id           = var.compartment_ocid
    operating_system         = "Oracle Linux"
    operating_system_version = "8"
    filter {
      name   = "display_name"
      values = ["^([a-zA-z]+)-([a-zA-z]+)-([\\.0-9]+)-([\\.0-9-]+)$"]
      regex  = true
    }
}

data "oci_core_images" "windows_server" {
    compartment_id           = var.compartment_ocid
    operating_system         = "Windows"
    operating_system_version = "Server 2019 Standard"
    filter {
      name = "display_name"
      values = ["^Windows-Server-2019-Standard-Edition-VM-([\\.0-9-]+)$"]
      regex  = true
    }
}

data "oci_core_instance_credentials" "instance_credentials" {
    for_each = {
      for server in local.instances : server.display_name =>  server
      if server.os_system == "Windows"
    }

    instance_id = oci_core_instance.instance[each.value.display_name].id
}

data "cloudinit_config" "config" {
    for_each = {
      for server in local.instances : server.display_name =>  server
      if server.os_system == "Windows"
    }

    gzip = false
    base64_encode = false

    part {
      filename = "cloudinit.ps1"
      content_type = "text/x-shellscript"
      content = templatefile("${path.module}/scripts/cloudinit.ps1", {
        user = var.user_ocid,
        pass = random_string.instance_password.result,
        host = each.value.display_name
      })
    }
}

data "oci_identity_availability_domain" "ad" {
    compartment_id = var.compartment_ocid
    ad_number      = var.ad_number
}

data "oci_identity_fault_domains" "fd" {
    compartment_id      = var.compartment_ocid
    availability_domain = data.oci_identity_availability_domain.ad.name
}

# filter by custom image
#data "oci_core_images" "oracle_linux" {
#    compartment_id           = var.compartment_ocid
#    filter {
#      name   = "display_name"
#      values = ["^([a-zA-z]+)-([a-zA-z]+)-([a-zA-z]+)-([0-9\\.0-9]+)$"]
#      regex  = true
#    }
#}

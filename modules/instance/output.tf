locals {
    instances_details = [
        for i in oci_core_instance.instance : <<EOT
          ${~i.display_name~}
          Primary-PublicIP: %{if i.public_ip != ""}${i.public_ip~}%{else}N/A%{endif~}
          Primary-PrivateIP: ${i.private_ip~}
        EOT
    ]
    instances_details_os = [
        distinct(flatten([
          for i in local.instances : [
            for j in range(1, i.no_of_instances+1) : {
              os_system = i.os_system
            }
          ]
        ]))
    ]
}

output "instances_summary" {
    description = "private and public IPs for each instance."
    value       = local.instances_details
}

output "username" {
    description = "user of the instance"
    value       = element([
        for x in local.instances_details_os : element([
            for y in range(0, length(x[*].os_system)) : x[y].os_system
        ], 1)], 0) == "Windows" ? var.user_ocid : null
}

output "password" {
    description = "pass of the instance"
    value       = element([
        for x in local.instances_details_os : element([
            for y in range(0, length(x[*].os_system)) : x[y].os_system
        ], 1)], 0) == "Windows" ? random_string.instance_password.result : null
}

output "ssh_to_instance" {
    description = "how to connect to instance"
    value       = element([
        for x in local.instances_details_os : element([
            for y in range(0, length(x[*].os_system)) : x[y].os_system
        ], 0)], 0) == "Linux" ? "ssh -vi key/private_key.pem -o StrictHostKeyChecking=no opc@Primary-PrivateIP" : null
}

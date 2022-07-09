output "username" {
    description = "user of the instance"
    type        = string
    value       = "Windows user: ${var.user_ocid}"
}

output "password" {
    description = "pass of the instance"
    type        = string
    value       = "Windows pass: ${random_string.instance_password.result}"
}

locals {
    instances_details = [
      for i in oci_core_instance.instance : <<EOT
      ${~i.display_name~}
      Primary-PublicIP: %{if i.public_ip != ""}${i.public_ip~}%{else}N/A%{endif~}
      Primary-PrivateIP: ${i.private_ip~}
      EOT
    ]
}

output "instances_summary" {
    description = "private and public IPs for each instance."
    value       = local.instances_details
}
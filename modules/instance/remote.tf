resource "null_resource" "wait_for_cloudinit" {
    depends_on = [
      oci_core_instance.instance,
      oci_core_volume_attachment.volume_attachment,
    ]

    provisioner "local-exec" {
      command = "sleep 60"
    }
}

resource "null_resource" "remote_exec_windows" {

    for_each = {
      for server in local.instances : server.display_name =>  server
      if server.os_system == "Windows"
    }

    depends_on = [
      oci_core_instance.instance,
      oci_core_volume_attachment.volume_attachment,
      null_resource.wait_for_cloudinit,
    ]

    provisioner "file" {
      connection {
        type     = "winrm"
        agent    = false
        timeout  = "1m"
        host     = oci_core_instance.instance[each.value.display_name].private_ip
        user     = data.oci_core_instance_credentials.instance_credentials[each.value.display_name].username
        password = random_string.instance_password.result
        port     = var.is_winrm_configured_for_ssl == "true" ? 5986 : 5985
        https    = var.is_winrm_configured_for_ssl
        insecure = "true"
      }

      content  = templatefile("${path.module}/scripts/setup.ps1", {
        IPV4 = "${oci_core_volume_attachment.volume_attachment[each.value.display_name].ipv4}",
        IQN  = "${oci_core_volume_attachment.volume_attachment[each.value.display_name].iqn}"
      })
      destination = "c:/setup.ps1"
    }

    provisioner "remote-exec" {
      connection {
        type     = "winrm"
        agent    = false
        timeout  = "1m"
        host     = oci_core_instance.instance[each.value.display_name].private_ip
        user     = data.oci_core_instance_credentials.instance_credentials[each.value.display_name].username
        password = random_string.instance_password.result
        port     = var.is_winrm_configured_for_ssl == "true" ? 5986 : 5985
        https    = var.is_winrm_configured_for_ssl
        insecure = "true"
      }

      inline = [
        "powershell.exe -file c:/setup.ps1",
      ]
    }
}

resource "null_resource" "remote_exec_linux" {

    for_each = {
      for server in local.instances : server.display_name =>  server
      if server.os_system == "Linux"
    }

    depends_on = [
      oci_core_instance.instance,
      oci_core_volume_attachment.volume_attachment,
    ]

    provisioner "remote-exec" {
      connection {
        type            = "ssh"
        target_platform = "unix"
        timeout         = "1m"
        user            = "opc"
        port            = "22"
        agent           = false
        host            = oci_core_instance.instance[each.value.display_name].private_ip
        private_key     = tls_private_key.key.private_key_pem
      }

      inline = [
        # load vars
        "export IQN='${oci_core_volume_attachment.volume_attachment[each.value.display_name].iqn}'",
        "export IPV4='${oci_core_volume_attachment.volume_attachment[each.value.display_name].ipv4}'",
        "export PORT='${oci_core_volume_attachment.volume_attachment[each.value.display_name].port}'",
        "export DEVICE='ip-'$IPV4':'$PORT'-iscsi-'$IQN'-lun-1'",
        # attach disk in os
        "sudo -i iscsiadm -m node -o new -T $IQN -p $IPV4:$PORT",
        "sudo -i iscsiadm -m node -o update -T $IQN -n node.startup -v automatic",
        "sudo -i iscsiadm -m node -T $IQN -p $IPV4:$PORT -l",
        # format disk in os
        "sudo -i [ -d /opt/controlm ] || sudo -i mkdir -p /opt/controlm",
        "(echo g; echo n; echo ''; echo ''; echo ''; echo w) | sudo -i fdisk /dev/disk/by-path/$DEVICE",
        "while [[ ! -e /dev/disk/by-path/$DEVICE-part1 ]]; do sleep 1; done",
        "sudo -i mkfs.ext4 -vF /dev/disk/by-path/$DEVICE-part1",
        "export UUID=$(sudo -i blkid -s UUID -o value /dev/disk/by-path/$DEVICE-part1)",
        "echo 'UUID='$UUID' /opt/controlm ext4 defaults,noatime,_netdev,nofail  0  10' | sudo -i tee -a /etc/fstab",
        "sudo -i mount -a",
        # resize disk boot
        "if [ $(grep -i ^version= /etc/os-release | awk -F '=' '{print $2}' | tr -d \\\"\\,\\.) -ge 80 ]; then",
            "sudo -i growpart /dev/sda 3",
            "sudo -i pvresize /dev/sda3",
            "sudo -i lvextend -r -l +100%FREE $(sudo -i df -hT | grep /$ | awk '{print $1}')",            
        "else",
            "sudo -i growpart /dev/sda 2",
            "sudo -i resize2fs /dev/sda2",
        "fi",
        # change hostname
        "sudo -i hostnamectl set-hostname ${each.value.display_name}",
        # update host
        "echo Updating your system!",
        "sudo -i yum -y update > /tmp/update.log",
      ]
    }
}
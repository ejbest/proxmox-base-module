resource "proxmox_cloud_init_disk" "ci" {
  depends_on = [var.pve_vm_depends_on]
  name       = var.cloud_init_disk_name
  pve_node   = var.proxmox_host_node
  storage    = var.iso_storage_pool

  meta_data = yamlencode({
    instance_id    = sha1(var.cloud_init_disk_name)
    local-hostname = var.cloud_init_disk_name
  })

  user_data = templatefile("${var.cloud_init_config_file}", {
    hostname    = var.hostname
    ssh_pub_key = tls_private_key.ssh_key.public_key_openssh
    ip_address  = "${var.ip_address}/24"
    gateway     = var.gateway
    ssh_user    = var.ssh_user

  })
}

resource "proxmox_vm_qemu" "proxmox_vm_qemu" {
  depends_on  = [proxmox_cloud_init_disk.ci, null_resource.ubuntu-template]
  count       = 1
  name        = var.hostname
  target_node = var.proxmox_host_node
  onboot      = true
  clone       = "ubuntu-cloud-template"
  vmid        = var.vmid
  agent       = 1
  os_type     = "cloud-init"
  cores       = var.cores
  sockets     = var.sockets
  cpu         = "host"
  memory      = var.memory
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  disks {
    scsi {
      scsi0 {
        disk {
          size     = var.disk_size
          storage  = var.storage_pool
          iothread = false
        }
      }
      scsi1 {
        cdrom {
          iso = "${proxmox_cloud_init_disk.ci.id}"
        }
      }
    }
  }

  ipconfig0 = var.ipconfig

  network {
    model    = "virtio"
    firewall = false
    bridge   = var.network_bridge
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = tls_private_key.ssh_key.private_key_pem
    host        = var.ip_address
  }

  provisioner "file" {
    source      = "${path.module}/files/progress_checker.sh"
    destination = "/tmp/progress_checker.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/progress_checker.sh"
    ]
  }

}

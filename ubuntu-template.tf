resource "null_resource" "ubuntu-template" {
  #triggers = {
  #  key = uuid()
  #}
  connection {
    type     = "ssh"
    user     = "root"
    password = var.proxmox_host_ssh_password
    host     = var.proxmox_host_ip_address
  }
  provisioner "file" {
    source      = "${path.module}/files/ubuntu_20_cloud_template.sh"
    destination = "/tmp/ubuntu_20_cloud_template.sh"
  }
  provisioner "file" {
    source      = "${path.module}/files/resolv.conf"
    destination = "/etc/resolv.conf"
  }

  provisioner "file" {
    source      = "${path.module}/files/pve-enterprise.list"
    destination = "/etc/apt/sources.list.d/pve-enterprise.list"
  }
  provisioner "file" {
    source      = "${path.module}/files/ceph.list"
    destination = "/etc/apt/sources.list.d/ceph.list"
  }
  provisioner "remote-exec" {
    inline = [
      "apt update -y",
      "chmod +x /tmp/ubuntu_20_cloud_template.sh",
      "/tmp/ubuntu_20_cloud_template.sh",
      "sleep 10s"

    ]
  }
}

output "private_key" {
  value = tls_private_key.ssh_key.private_key_openssh
}

output "cloud_init_disk_id" {
  description = "The ID of the cloud-init disk"
  value       = proxmox_cloud_init_disk.ci.id
}
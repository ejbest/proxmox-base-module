resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "pem_file" {
  filename        = var.private_ssh_keyname
  file_permission = "400"
  content         = tls_private_key.ssh_key.private_key_pem
}


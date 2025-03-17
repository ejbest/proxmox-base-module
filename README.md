# Proxmox Terraform Base Module

This Terraform module provides a foundational setup for deploying virtual machines and containers on Proxmox VE. It encapsulates common configurations and best practices, allowing for consistent and repeatable deployments.

## Features

* **VM and Container Creation:** Simplifies the creation of Proxmox VMs and LXC containers.
* **Networking Configuration:** Manages network interfaces, bridges, and VLANs.
* **Storage Management:** Handles storage pools and disk configurations.
* **Cloud-Init Support:** Integrates with Cloud-Init for initial VM/container configuration.
* **Template Support:** Enables deployment from existing Proxmox templates.
* **Resource Customization:** Allows fine-grained control over CPU, memory, and disk resources.
* **Firewall Management:** Basic firewall rule management.
* **SSH Key Injection:** Injects SSH keys for secure access.

## Prerequisites

* Terraform installed (version >= 1.0 recommended).
* Proxmox VE server accessible via API.
* Proxmox API token or user credentials.
* Appropriate Proxmox storage and network configurations.

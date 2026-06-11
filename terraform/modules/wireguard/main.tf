locals {
  cloud_init = templatefile("${path.module}/templates/cloud-init.yaml.tpl", {
    public_ip      = var.public_ip
    wireguard_port = var.wireguard_port
    vpn_subnet     = var.vpn_subnet
  })
}
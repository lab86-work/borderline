output "vpn_server_ip" {
  description = "Public IP of the VPN server"
  value       = module.vm.public_ip
}

output "ssh_command" {
  description = "SSH command to access the server"
  value       = "ssh -i <key-path> ubuntu@${module.vm.public_ip}"
}

output "retrieve_client_config" {
  description = "Command to retrieve the client WireGuard config"
  value       = "scp ubuntu@${module.vm.public_ip}:/opt/wireguard/clients/client.conf ./client.conf"
}

output "retrieve_qr_code" {
  description = "Command to retrieve the QR code for Android/Google TV"
  value       = "scp ubuntu@${module.vm.public_ip}:/opt/wireguard/clients/client.qr ./client.png"
}
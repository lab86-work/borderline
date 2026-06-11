variable "public_ip" {
  description = "Public IP of the VPN server"
  type        = string
}

variable "wireguard_port" {
  description = "WireGuard UDP port"
  type        = number
  default     = 51820
}

variable "vpn_subnet" {
  description = "VPN subnet prefix (e.g. 10.8.0)"
  type        = string
  default     = "10.8.0"
}

variable "ssh_private_key" {
  description = "SSH private key for remote-exec"
  type        = string
  sensitive   = true
  default     = null
}

variable "ssh_private_key_path" {
  description = "Path to SSH private key file for local-exec"
  type        = string
  default     = null
}
variable "name" {
  description = "Resource name prefix"
  type        = string
}

variable "cidr_block" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "wireguard_port" {
  description = "WireGuard UDP port"
  type        = number
  default     = 51820
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH (required — set to YOUR_IP/32)"
  type        = list(string)
}
variable "name" {
  description = "Resource name prefix"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t4g.nano"
}

variable "subnet_id" {
  description = "Subnet ID to launch into"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "user_data" {
  description = "Cloud-init user data"
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 10
}
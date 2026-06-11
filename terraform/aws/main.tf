terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "http" "my_ip" {
  url = "https://ifconfig.me"
}

locals {
  wireguard_port    = 51820
  vpn_subnet        = "10.8.0"
  caller_ip         = "${chomp(data.http.my_ip.response_body)}/32"
  allowed_ssh_cidrs = var.allowed_ssh_cidrs != null ? var.allowed_ssh_cidrs : [local.caller_ip]
}

module "vpc" {
  source = "../modules/vpc"

  name              = var.name
  wireguard_port    = local.wireguard_port
  allowed_ssh_cidrs = local.allowed_ssh_cidrs
}

module "wireguard" {
  source = "../modules/wireguard"

  public_ip      = module.vm.public_ip
  wireguard_port = local.wireguard_port
  vpn_subnet     = local.vpn_subnet
}

module "vm" {
  source = "../modules/vm"

  name              = var.name
  instance_type     = var.instance_type
  subnet_id         = module.vpc.subnet_id
  security_group_id = module.vpc.security_group_id
  ssh_public_key    = var.ssh_public_key
  user_data         = module.wireguard.cloud_init
}
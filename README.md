# Borderline

Terraform-based VPN deployment — launch an AWS EC2 instance, install WireGuard,
and generate credentials for Android / Google TV clients.

## Decision

| Layer | Choice | Rationale |
|-------|--------|-----------|
| Provider | **AWS sa-east-1** | Only reliable option with Brazil region; t4g.nano at $0.0042/hr (~$3/mo) |
| Instance | **t4g.nano** (ARM/Graviton, 2 vCPU, 0.5 GB) | Cheapest reliable VM in sa-east-1 |
| VPN | **WireGuard** | Native Android TV app, OPNsense plugin, lowest overhead, QR code import |

## Quick start

```bash
cd terraform/aws
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars with your SSH key
terraform init
terraform apply
```

After apply, retrieve the client config:

```bash
scp ubuntu@$(terraform output -raw vpn_server_ip):/opt/wireguard/clients/client.conf .
# or for QR code (Android TV / Google TV):
scp ubuntu@$(terraform output -raw vpn_server_ip):/opt/wireguard/clients/client.qr ./client.png
```

## Client setup guides

| Client | Guide |
|--------|-------|
| Android phone | `doc/guides/android-phone.md` |
| Google TV / Android TV | `doc/guides/google-tv.md` |
| OPNsense | `doc/guides/opnsense.md` |

## Project structure

```
├── README.md
├── TODO.md
├── doc/
│   ├── architecture/       — design decisions and system overview
│   └── research/
│       ├── aws/            — AWS provider evaluation
│       ├── azure/          — Azure provider evaluation
│       ├── google/         — Google Cloud provider evaluation
│       ├── oracle/         — Oracle Cloud provider evaluation
│       ├── comparison.md   — side-by-side provider comparison
│       └── vpn.md          — VPN solution evaluation
└── terraform/
    ├── modules/
    │   ├── vpc/            — VPC, subnet, security group
    │   ├── vm/             — EC2 instance, Elastic IP, SSH key
    │   └── wireguard/      — cloud-init, config generation
    └── aws/                — root Terraform config (AWS)
```

## Status

Terraform code written. Ready for validation / `terraform apply`.
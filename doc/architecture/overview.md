# Architecture overview

## High-level design

```
┌─────────────┐     WireGuard      ┌──────────────────────┐
│  Client      │ ◄══════════════►  │  Cloud VM             │
│  (Android TV │    UDP :51820     │  (e2-micro / t4g.nano │
│   / Google TV│                    │   / B1s)              │
│   / Linux    │                    │                       │
│   / OPNsense)│                    │  ┌─────────────────┐  │
└─────────────┘                    │  │  WireGuard       │  │
                                   │  │  iptables NAT    │  │
                                   │  │  QR code gen     │  │
                                   │  └─────────────────┘  │
                                   └──────────────────────┘
                                              │
                                              ▼
                                          Internet
                                         (streaming)
```

## Principles

1. **Single-tenant**: One VM, one client (for now). Simplicity over scale.
2. **Immutable infrastructure**: VM built from a base image + cloud-init.
   Terraform is the single source of truth.
3. **Minimal attack surface**: No unnecessary ports. Only WireGuard UDP (custom
   port) and SSH (locked to key auth, optionally disabled after setup).
4. **Credentials as output**: Terraform outputs a WireGuard config file + QR
   code PNG. No manual steps.

## Provider decision

To be determined by research. Initial candidates (reliability-weighted):
- **Google Cloud e2-micro** — reliably available always-free tier, 100 GB free
  egress, excellent global network. Front-runner.
- **AWS Lightsail $3.50** — reliable, 1 TB included bandwidth, simple. Best
  paid option.
- **Azure B1s** — VM is always-free, but 15 GB free egress is too tight for
  regular HD streaming.
- **Oracle Cloud A1.Flex** — best specs on paper ($0, 4 OCPU, 24 GB, 10 TB
  egress), but persistent capacity shortages make it unreliable for automated
  provisioning. Not recommended.

## VPN decision

**WireGuard** — see `doc/research/vpn.md` for rationale.

## Terraform module layout (future)

```
terraform/
├── modules/
│   ├── vpc/              — VPC, subnet, firewall rules
│   ├── vm/               — instance, public IP, SSH key
│   └── wireguard/        — config generation, cloud-init, QR code
├── aws/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── azure/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── google/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── oracle/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

## Deployment flow

1. `terraform apply` creates the VM and outputs the client config.
2. cloud-init installs WireGuard, generates server keys, and applies `sysctl`
   for IP forwarding + NAT.
3. Client scans QR code (Android TV) or copies config file (Linux/OPNsense).
4. Traffic flows through the tunnel; DNS can be routed through the VM to avoid
   leaks.

## Future considerations

- **Monitoring**: Prometheus node_exporter + WireGuard metrics (wg_exporter).
- **Auto-shutdown**: If no traffic for N hours, stop the VM to save cost.
- **Multiple clients**: Extend to 2-3 clients with separate keys.
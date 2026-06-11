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

**AWS — sa-east-1 (São Paulo), t4g.nano ($0.0042/hr)**

Rationale:
- Brazil region required → GCP/Azure/Oracle always-free tiers not available or unreliable in Brazil.
- t4g.nano at ~$3/mo is the cheapest reliable option in sa-east-1.
- 100 GB free egress covers light HD streaming; beyond that, $0.09/GB is manageable.
- Lightsail not available in Brazil, so standard EC2 with t4g.nano is the path.

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
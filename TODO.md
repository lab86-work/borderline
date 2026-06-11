# TODO

## Phase 1 — Provider research

- [x] Evaluate **AWS** — Lightsail vs EC2 t4g.nano/micro, egress pricing, regional latency, streaming-friendly ToS
- [x] Evaluate **Azure** — B1s always-free, egress pricing, streaming-friendly ToS
- [x] Evaluate **Google Cloud** — e2-micro / f1-micro always-free, egress pricing, streaming-friendly ToS
- [x] Evaluate **Oracle Cloud** — A1.Flex (4 OCPU, 24 GB, 10 TB egress) always-free, **ruled out due to persistent capacity constraints**
- [ ] Compare providers on cost (monthly), bandwidth caps, and HD-streaming feasibility
- [ ] **Decision**: pick one provider for the initial implementation

## Phase 2 — VPN research

- [ ] Research **WireGuard** as primary candidate (lightweight, kernel-level, Android/Google TV app)
- [ ] Research **OpenVPN** (mature, wide client support, OPNsense friendly)
- [ ] Research **Tailscale / Headscale** (mesh-based, NAT traversal, but dependency on coordinator)
- [ ] Research **SoftEther** (multi-protocol, OPNsense plugin available)
- [ ] Evaluate each VPN on:
  - Android / Google TV client availability
  - Linux proxy mode (SOCKS5 / HTTP / tun)
  - OPNsense integration
  - Performance overhead for HD streaming
- [ ] **Decision**: pick one VPN solution

## Phase 3 — Architecture & Terraform

- [ ] Design Terraform module layout (provider agnostic + provider-specific)
- [ ] Write basic Terraform config for chosen provider (VPC, firewall, VM, keypair)
- [ ] Write cloud-init / Ansible / provisioner to install VPN
- [ ] Automate credential generation for clients (QR code / config file)
- [ ] Validate end-to-end: deploy, connect from Android/Google TV, stream

## Phase 4 — Optional / stretch

- [ ] OPNsense integration guide
- [ ] Linux proxy mode setup guide
- [ ] Investigate Oracle capacity constraints — script to poll for A1.Flex availability across regions (low priority, ruled out for now)
- [ ] Multi-region failover?
- [ ] Prometheus / Grafana monitoring for the VPN node
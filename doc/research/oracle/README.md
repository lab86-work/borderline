# Oracle Cloud provider evaluation

## Always-Free tier (no time limit)

- **VM.Standard.A1.Flex** (Ampere ARM): ✅ Up to **4 OCPUs, 24 GB RAM** —
  **always free**. This is by far the most generous always-free compute
  offering from any major cloud provider.
- **VM.Standard.E2.1.Micro** (AMD x86): ✅ 1 OCPU, 1 GB RAM — always free.
- **Bandwidth**: **10 TB outbound per month** (always free) — massively
  generous.
- **Disk**: Up to 200 GB total for block volumes (always free).
- **Restrictions**: You must stay within the always-free resource limits
  (max 4 OCPUs, 24 GB RAM total across all A1 instances). Only available in
  specific always-free eligible regions (check Oracle docs for current list:
  US East, US West, UK South, Germany Central, Japan East, etc.).

> This is an exceptional deal: **4-core ARM, 24 GB RAM, 10 TB egress, $0**.

## VM candidates

| Instance              | vCPU | RAM  | Monthly (always-free) | Notes                            |
|-----------------------|------|------|-----------------------|----------------------------------|
| VM.Standard.A1.Flex   | up to 4 | up to 24G | $0         | ARM Ampere, highly configurable  |
| VM.Standard.E2.1.Micro| 1    | 1G   | $0                    | AMD x86, basic option            |

## Egress pricing

- **10 TB/mo free** — extraordinary. Covers even very heavy HD streaming.
- **Beyond**: $0.0085/GB – $0.025/GB (regional variation).

## Streaming considerations

- **10 TB free egress** is game-changing — ~10,000 hours of 8 Mbps HD
  streaming per month. Essentially unlimited for a single user.
- The A1.Flex with 4 OCPUs is vastly overprovisioned for a single WireGuard
  tunnel, but the cost is $0 so there's no downside.
- If A1.Flex capacity is unavailable in your region (Oracle often has capacity
  constraints), the E2.1.Micro (1 GB) is still adequate for WireGuard.

## Notes

- **Capacity constraints**: Oracle's always-free ARM instances (A1) are often
  "out of capacity" in popular regions. You may need to try multiple
  availability domains or regions. This is the main practical downside.
- The E2.1.Micro (x86, 1 GB) is more reliably available.
- SSH key authentication required (password auth disabled by default).
- Terraform provider is mature but slightly different from AWS/Azure/GCP
  (uses OCID-based resource identifiers).

## Verdict

**Not recommended for this project.** The A1.Flex capacity shortage is a
persistent, well-documented issue — accounts routinely fail to provision for
weeks or months. A Terraform pipeline that unpredictably fails is not useful.
If capacity is ever reliably available in the future, this becomes the obvious
choice.

## Open questions

- Does Oracle's networking support IPv6 for the free tier? (Useful for some
  streaming services.)
- Does Oracle's ToS restrict VPN / tunneling use? (Generally permitted, but
  verify against Acceptable Use Policy.)
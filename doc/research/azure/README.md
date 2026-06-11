# Azure provider evaluation

## Always-Free tier (no time limit)

- **B1s Linux VM**: ✅ 750 hours/month (1 vCPU, 1 GB RAM) — **always free**.
- **Managed disk**: 64 GB included.
- **Bandwidth**: 15 GB outbound per month (always free).
- **Restrictions**: Only one free B1s per subscription. Must use Linux (not
  Windows).

This is a legitimate always-free offering — no 12-month expiry.

## VM candidates

| Instance | vCPU | RAM  | Monthly (always-free) | Notes                              |
|----------|------|------|-----------------------|------------------------------------|
| B1s      | 1    | 1G   | $0                    | Always free, 750 h/month          |
| B2s      | 2    | 4G   | ~$27 (paid)           | Upgrade option                     |

## Egress pricing

- **15 GB/mo free** (always-free).
- **Beyond**: $0.087/GB – $0.12/GB depending on zone.

## Streaming considerations

- **15 GB free egress** is very low — ~14 hours of 8 Mbps HD streaming.
- For regular HD use, you'll exceed the free egress quickly and pay $0.09+/GB.
- The VM itself is free, but bandwidth costs make streaming expensive vs
  competitors.

## Notes

- B1s (1 vCPU, 1 GB RAM) is enough for WireGuard for a single client.
- 750 hours/month = ~25 hours/day — plenty for a 24/7 VPN.
- Azure's network backbone is excellent for latency-sensitive streaming.

## Open questions

- Is the free B1s good enough for a WireGuard tunnel? (Yes, WireGuard is
  extremely lightweight.)
- Is the 15 GB egress cap a dealbreaker for HD streaming? (Likely yes — you'd
  need the paid tier and bandwidth.)
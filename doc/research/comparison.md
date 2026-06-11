# Provider comparison

## Brazil region (São Paulo) — price per hour, no commitment

| Provider | Region | Cheapest VM | $/hr | Free tier in Brazil? | Egress $/GB | Free egress/mo | Reliable capacity? |
|----------|--------|-------------|------|---------------------|-------------|---------------|--------------------|
| AWS      | sa-east-1 | t4g.nano  | $0.0042 | ❌ (12mo only)       | $0.09       | 100 GB        | ✅ Yes             |
| AWS      | sa-east-1 | t4g.micro | $0.0084 | ❌ (12mo only)       | $0.09       | 100 GB        | ✅ Yes             |
| GCP      | southamerica-east1 | e2-micro | $0.0520 | ❌ (US only)         | $0.19       | 1 GB          | ✅ Yes             |
| Azure    | brazilsouth | B1s      | $0.0412 | ❌                    | $0.181      | 100 GB        | ✅ Yes             |
| Oracle   | sa-saopaulo-1 | A1.Flex | $0.0000 | ✅ Yes               | $0.00 (up to 10 TB) | 10 TB  | ❌ Capacity shortages |

## Key takeaways

### Always-free tiers in Brazil
- **None of the major providers offer an always-free VM in Brazil.**
- GCP's e2-micro always-free is **US regions only**. In southamerica-east1 it's $0.052/hr (~$37/mo).
- Oracle is the only always-free option in Brazil, but capacity is unreliable.

### Cheapest reliable option in Brazil
- **AWS t4g.nano at $0.0042/hr (~$3/mo)** is the clear winner for Brazil.
- Even after the 12-month free tier expires, $3/mo is negligible.

### Egress costs in Brazil
- All providers charge **2-3x more** for egress from South America vs US/EU.
- AWS sa-east-1 egress starts at $0.09/GB — cheapest paid option.
- At 8 Mbps HD streaming (~2.6 GB/hour), e.g. 2 h/day = ~160 GB/mo:
  - AWS: ~$5.40/mo over the 100 GB free tier
  - GCP: ~$30/mo (only 1 GB free)
  - Azure: ~$11/mo

### Non-Brazil option (US region)
If the user is open to a US region, everything changes:

| Provider | VM $/hr | Free egress/mo | Est. monthly cost (moderate HD) |
|----------|---------|---------------|--------------------------------|
| **GCP e2-micro (US)** | **$0.0000** | **100 GB** | **$0 – $5** |
| AWS t4g.nano (US)     | $0.0042  | 100 GB        | $3 – $8       |
| Azure B1s (US)        | $0.0000 (always-free 750h) | 100 GB | $0 – $8    |

> GCP e2-micro in a US region is $0/mo for the VM, with 100 GB free egress —
> enough for ~38 hours of HD streaming. Beyond that, $0.085/GB. This is the
> best balance of cost and reliability **if US latency is acceptable**.

## Recommendation

| Scenario | Best pick | Why |
|----------|-----------|-----|
| **Brazil region required** | AWS t4g.nano ($0.0042/hr) | Cheapest reliable VM, lowest egress cost in Brazil |
| **US region acceptable** | GCP e2-micro ($0 always-free) | VM + 100 GB egress free, excellent network, reliable |
| **Max bandwidth / no budget** | Oracle A1.Flex ($0) | Best specs, but capacity lottery—not for production/automation |

## Open questions

- Is the user in Brazil, or just targeting Brazilian streaming content?
- If outside Brazil, is latency from a US region acceptable for the client's
  streaming setup?
- What is the expected monthly HD streaming volume (hours/day, bitrate)?
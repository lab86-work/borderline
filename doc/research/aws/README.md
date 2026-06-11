# AWS provider evaluation

## Always-Free tier (no time limit)

- **EC2**: None. The free tier (`t2.micro`) is limited to 12 months.
- **Lightsail**: No always-free tier.
- **Total**: No always-free compute option.

## VM candidates (paid)

| Instance   | vCPU | RAM  | Monthly (on-demand) | Notes                              |
|------------|------|------|---------------------|------------------------------------|
| t4g.nano   | 2    | 0.5G | ~$4.70              | ARM, cheapest EC2                 |
| Lightsail  | 1    | 1G   | $3.50               | 1 TB transfer included             |

## Egress pricing

- $0.09/GB after free tier expires (EC2 — no always-free allowance).
- Lightsail: 1 TB included on $3.50 plan, $0.04/GB overage.

## Streaming considerations

- Lightsail is the most cost-effective AWS option — 1 TB is ~330 hours of 8 Mbps HD.
- EC2 egress gets expensive fast — no always-free buffer.
- AWS does not explicitly forbid VPN hosting on general-purpose instances.

## Open questions

- Can Lightsail's fixed firewall rules handle WireGuard without extra VPC
  configuration?
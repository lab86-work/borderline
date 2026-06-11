# Google Cloud provider evaluation

## Always-Free tier (no time limit)

- **f1-micro VM**: ✅ 1 vCPU, 0.6 GB RAM — **always free** (per month, in US
  regions only).
- **e2-micro VM**: ✅ 2 vCPU (burst), 1 GB RAM — **always free** (per month,
  in US regions only).
- **Bandwidth**: 100 GB outbound per month (always free, aggregate across all
  GCP services).
- **Disk**: 30 GB HDD or 10 GB SSD (always free).
- **Restrictions**: Limited to specific regions (us-west1, us-central1,
  us-east1 typically qualify). One free VM per billing account for each of
  f1-micro and e2-micro.

> ⚠️ Important: you are billed if the VM runs **more than 744 hours per
> month** (i.e. 24/7). The always-free tier covers **one f1-micro OR one
> e2-micro** for the full month. Running both simultaneously will exceed the
> free monthly hours.

## VM candidates

| Instance | vCPU   | RAM  | Monthly (always-free) | Notes                            |
|----------|--------|------|-----------------------|----------------------------------|
| f1-micro | 1      | 0.6G | $0                    | Always free, US regions only     |
| e2-micro | 2 (burst) | 1G | $0                    | Always free, US regions only     |

## Egress pricing

- **100 GB/mo free** (always-free).
- **Beyond**: $0.085/GB – $0.12/GB (premium tier). Standard tier from US to
  certain regions is ~$0.04/GB.

## Streaming considerations

- 100 GB free egress covers ~100 hours of 8 Mbps HD streaming per month.
- For light-to-moderate HD usage (2-3 h/day), this is sufficient at **$0**.
- Beyond 100 GB, costs are manageable (~$0.085/GB).
- f1-micro with 0.6 GB RAM might be tight for WireGuard + system overhead;
  e2-micro (1 GB) is safer.

## Notes

- e2-micro (1 GB RAM, 2 burst vCPU) is recommended over f1-micro (0.6 GB) for
  WireGuard reliability.
- GCP's global network backbone is excellent — good latency for streaming.
- $300 free credits for 90 days + always-free tier gives plenty of budget for
  prototyping.

## Open questions

- Is f1-micro (0.6 GB RAM) sufficient for WireGuard without swapping? (Should
  be, but e2-micro is safer.)
- US-only restrictions on free tier — is latency to your streaming source
  acceptable from us-west1/us-central1/us-east1?
# Borderline

Terraform-based VPN deployment — launch a cloud VM, install a VPN, and generate
credentials for Android / Google TV clients (or use it as a Linux proxy, or
integrate with OPNsense).

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
│       └── oracle/         — Oracle Cloud provider evaluation
└── terraform/              — (future) Terraform configurations
    ├── aws/
    ├── azure/
    ├── google/
    └── oracle/
```

## Goal

1. Pick the **best cloud provider** for a single-VM, single-client VPN that can
   stream HD TV.
2. Pick the **best VPN solution** that works on Android TV / Google TV, as a
   Linux SOCKS/HTTP proxy, or inside OPNsense.
3. Automate everything with Terraform.

## Status

Exploratory / research phase. No code yet.
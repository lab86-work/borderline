# Android phone — WireGuard client setup

## Prerequisites

- VPN server deployed and running
- Client config file (`client.conf`) retrieved from server

## Steps

1. Install **WireGuard** from the Play Store.

2. Open WireGuard and tap **+** → **Import from file or archive**.

3. Navigate to and select the `client.conf` you retrieved from the server.

4. Tap **Save** (top-right).

5. Tap the toggle next to the tunnel name to connect.

   A key icon in the status bar confirms the VPN is active.

## Retrieving the config from the server

```bash
scp ubuntu@<server-ip>:/opt/wireguard/clients/client.conf .
```

Transfer the file to your phone via USB, cloud storage, or a QR scan (see
Google TV guide for QR method).

## Troubleshooting

- **No handshake** → check that UDP port 51820 is open on the server security
  group.
- **DNS leaks** → the config already sets DNS to 1.1.1.1 / 1.0.0.1. Verify at
  dnsleaktest.com.
- **Slow speeds** → ensure you're on 5 GHz Wi-Fi or mobile data with good
  signal. WireGuard adds <5% overhead on a t4g.nano.
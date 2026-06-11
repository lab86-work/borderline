# OPNsense — WireGuard client setup

## Prerequisites

- VPN server deployed and running
- Client config file (`client.conf`) retrieved from server

## Steps

### 1. Install the WireGuard plugin

- Navigate to **System** → **Firmware** → **Plugins**.
- Search for `os-wireguard` and click **Install**.

### 2. Import the client config

- Go to **VPN** → **WireGuard** → **Endpoints**.
- Click **Import** and paste the `[Peer]` section of `client.conf`:

  ```
  PublicKey = <server-public-key>
  PresharedKey = <psk>
  Endpoint = <server-ip>:51820
  AllowedIPs = 0.0.0.0/0
  PersistentKeepalive = 25
  ```

- Click **Save**.

### 3. Create the local instance

- Go to **VPN** → **WireGuard** → **Local**.
- Click **Add**.
- Set **Enabled**, **Private Key** (from the `[Interface]` section of
  `client.conf`), **Listen Port** (any free port, e.g. 51821), and **Tunnel
  Address** (e.g. `10.8.0.2/24`).
- Under **Peers**, add the endpoint you created in step 2.
- Click **Save**, then **Apply**.

### 4. Route traffic through the tunnel

- Go to **Firewall** → **Rules** → **[WAN]**.
- Add a rule to allow outbound from the WireGuard interface (or use the
  default any-any if the tunnel is your default gateway).

- Go to **System** → **Gateways** → **Single**.
- A gateway for the WireGuard endpoint should auto-appear.

- Go to **System** → **Routing** → **Default gateway**.
- Set the default gateway to the WireGuard interface.

  > Alternatively, create policy-based rules to route only specific LAN
  > traffic (e.g., a dedicated IoT VLAN) through the VPN.

### 5. Verify

- Go to **VPN** → **WireGuard** → **Status**.
- Confirm the tunnel shows **Handshake** and recent transfer counters.

## Alternative: full-tunnel site config

If you prefer the entire OPNsense WAN to route through the VPN (all LAN
clients use the tunnel as their internet gateway):

1. Create an interface assignment for `wg0` (Interfaces → Assignments).
2. Enable the interface with no IP (just bridge it).
3. Set the default gateway to the WireGuard gateway.
4. Add an outbound NAT rule for the `wg0` interface.

## Troubleshooting

- **No handshake** → check the endpoint IP/port is reachable from OPNsense
  WAN. Verify the server's security group allows UDP 51820.
- **DNS leaks** → under **System** → **Settings** → **General**, set DNS
  servers to 1.1.1.1 and 1.0.0.1.
- **Kill switch** → add a firewall rule that blocks all WAN traffic if the
  WireGuard interface is down (use a gateway group).